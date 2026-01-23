import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/question_bank.dart';
import '../data/repositories/bank_repository.dart';
import 'database_provider.dart';

/// 本地题库列表Provider
/// 
/// 获取所有已下载到本地的题库
final localBanksProvider = FutureProvider<List<QuestionBank>>((ref) async {
  final repository = ref.watch(bankRepositoryProvider);
  return await repository.getLocalBanks();
});

/// 远程题库列表Provider
/// 
/// 从服务器获取可用的题库列表
final remoteBanksProvider = FutureProvider<List<QuestionBankInfo>>((ref) async {
  final repository = ref.watch(bankRepositoryProvider);
  return await repository.fetchBankList();
});

/// 指定题库Provider
/// 
/// 根据ID获取单个题库的详细信息
final bankByIdProvider = FutureProvider.family<QuestionBank?, String>((ref, bankId) async {
  final repository = ref.watch(bankRepositoryProvider);
  return await repository.getLocalBankById(bankId);
});

/// 题库下载状态Provider
/// 
/// 检查指定题库是否已下载
final bankDownloadedProvider = FutureProvider.family<bool, String>((ref, bankId) async {
  final repository = ref.watch(bankRepositoryProvider);
  return await repository.isBankDownloaded(bankId);
});

/// 题库下载进度状态
class DownloadProgress {
  final String bankId;
  final int received;
  final int total;
  final bool isDownloading;
  final String? error;

  DownloadProgress({
    required this.bankId,
    required this.received,
    required this.total,
    required this.isDownloading,
    this.error,
  });

  double get progress => total > 0 ? received / total : 0.0;
  
  bool get isComplete => received >= total && total > 0;

  DownloadProgress copyWith({
    String? bankId,
    int? received,
    int? total,
    bool? isDownloading,
    String? error,
  }) {
    return DownloadProgress(
      bankId: bankId ?? this.bankId,
      received: received ?? this.received,
      total: total ?? this.total,
      isDownloading: isDownloading ?? this.isDownloading,
      error: error ?? this.error,
    );
  }
}

/// 题库下载管理器Provider
/// 
/// 管理题库下载的状态和操作
class BankDownloadNotifier extends StateNotifier<Map<String, DownloadProgress>> {
  final BankRepository _repository;

  BankDownloadNotifier(this._repository) : super({});

  /// 开始下载题库
  Future<bool> downloadBank(String bankId) async {
    // 初始化下载状态
    state = {
      ...state,
      bankId: DownloadProgress(
        bankId: bankId,
        received: 0,
        total: 0,
        isDownloading: true,
      ),
    };

    try {
      // 下载题库
      final bank = await _repository.downloadBank(
        bankId,
        onProgress: (received, total) {
          // 更新下载进度
          state = {
            ...state,
            bankId: DownloadProgress(
              bankId: bankId,
              received: received,
              total: total,
              isDownloading: true,
            ),
          };
        },
      );

      // 保存到本地数据库
      await _repository.saveBankToLocal(bank);

      // 更新为完成状态
      state = {
        ...state,
        bankId: DownloadProgress(
          bankId: bankId,
          received: 100,
          total: 100,
          isDownloading: false,
        ),
      };

      // 1秒后清除下载状态
      Future.delayed(const Duration(seconds: 1), () {
        final newState = Map<String, DownloadProgress>.from(state);
        newState.remove(bankId);
        state = newState;
      });

      return true;
    } catch (e) {
      // 下载失败
      state = {
        ...state,
        bankId: DownloadProgress(
          bankId: bankId,
          received: 0,
          total: 0,
          isDownloading: false,
          error: e.toString(),
        ),
      };

      return false;
    }
  }

  /// 删除本地题库
  Future<void> deleteBank(String bankId) async {
    await _repository.deleteLocalBank(bankId);
    
    // 清除下载状态
    final newState = Map<String, DownloadProgress>.from(state);
    newState.remove(bankId);
    state = newState;
  }

  /// 清除下载状态
  void clearDownloadProgress(String bankId) {
    final newState = Map<String, DownloadProgress>.from(state);
    newState.remove(bankId);
    state = newState;
  }
}

/// 题库下载管理器Provider实例
final bankDownloadProvider = StateNotifierProvider<BankDownloadNotifier, Map<String, DownloadProgress>>((ref) {
  final repository = ref.watch(bankRepositoryProvider);
  return BankDownloadNotifier(repository);
});

/// 当前选中的题库ID Provider
final selectedBankIdProvider = StateProvider<String?>((ref) => null);

/// 当前选中的题库详情Provider
final selectedBankProvider = FutureProvider<QuestionBank?>((ref) async {
  final bankId = ref.watch(selectedBankIdProvider);
  
  if (bankId == null) return null;
  
  final repository = ref.watch(bankRepositoryProvider);
  return await repository.getLocalBankById(bankId);
});
