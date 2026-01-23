import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import '../../core/database/database.dart';
import '../../core/network/api_client.dart';
import '../models/question_bank.dart' as models;

/// 题库数据仓库
/// 
/// 负责题库相关的数据操作
class BankRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;

  BankRepository({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _database = database,
        _apiClient = apiClient;

  /// 从服务器获取题库列表
  Future<List<models.QuestionBankInfo>> fetchBankList() async {
    final banksData = await _apiClient.getBankList();
    return banksData
        .map((json) => models.QuestionBankInfo.fromJson(json))
        .toList();
  }

  /// 从服务器下载题库
  /// 
  /// [bankId] 题库ID
  /// [onProgress] 下载进度回调 (已下载字节, 总字节)
  Future<models.QuestionBank> downloadBank(
    String bankId, {
    void Function(int received, int total)? onProgress,
  }) async {
    final bankData = await _apiClient.downloadBank(
      bankId,
      onProgress: onProgress,
    );
    return models.QuestionBank.fromJson(bankData);
  }

  /// 保存题库到本地数据库
  Future<void> saveBankToLocal(models.QuestionBank bank) async {
    final companion = QuestionBanksCompanion.insert(
      id: bank.id,
      name: bank.name,
      version: bank.version,
      totalQuestions: bank.totalQuestions,
      language: bank.language,
      downloadedAt: DateTime.now(),
      data: jsonEncode(bank.toJson()),
    );

    await _database.into(_database.questionBanks).insert(
          companion,
          mode: drift.InsertMode.replace,
        );
  }

  /// 获取所有本地题库
  Future<List<models.QuestionBank>> getLocalBanks() async {
    final rows = await _database.select(_database.questionBanks).get();
    
    return rows.map((row) {
      final bankData = jsonDecode(row.data) as Map<String, dynamic>;
      return models.QuestionBank.fromJson(bankData);
    }).toList();
  }

  /// 根据ID获取本地题库
  Future<models.QuestionBank?> getLocalBankById(String bankId) async {
    final query = _database.select(_database.questionBanks)
      ..where((tbl) => tbl.id.equals(bankId));
    
    final row = await query.getSingleOrNull();
    
    if (row == null) return null;
    
    final bankData = jsonDecode(row.data) as Map<String, dynamic>;
    return models.QuestionBank.fromJson(bankData);
  }

  /// 删除本地题库
  Future<void> deleteLocalBank(String bankId) async {
    await (_database.delete(_database.questionBanks)
          ..where((tbl) => tbl.id.equals(bankId)))
        .go();
  }

  /// 检查题库是否已下载
  Future<bool> isBankDownloaded(String bankId) async {
    final query = _database.select(_database.questionBanks)
      ..where((tbl) => tbl.id.equals(bankId));
    
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// 获取题库下载时间
  Future<DateTime?> getBankDownloadTime(String bankId) async {
    final query = _database.select(_database.questionBanks)
      ..where((tbl) => tbl.id.equals(bankId));
    
    final row = await query.getSingleOrNull();
    return row?.downloadedAt;
  }
}
