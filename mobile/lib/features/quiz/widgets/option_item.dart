import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 选项组件
/// 
/// 显示单个选项，支持选中、正确、错误状态
class OptionItem extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final bool? isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;

  const OptionItem({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    this.isCorrect,
    this.isWrong = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 确定颜色和边框
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;
    IconData? icon;

    if (isCorrect == true) {
      // 正确答案
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
      textColor = Colors.green.shade700;
      icon = Icons.check_circle;
    } else if (isWrong) {
      // 错误答案
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red;
      textColor = Colors.red.shade700;
      icon = Icons.cancel;
    } else if (isSelected) {
      // 选中但未提交
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      borderColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.primary;
      icon = Icons.check_circle_outline;
    } else {
      // 未选中
      backgroundColor = Theme.of(context).colorScheme.surface;
      borderColor = Theme.of(context).colorScheme.outline.withOpacity(0.2);
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: borderColor,
              width: isSelected || isCorrect == true || isWrong ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // 选项标签（A/B/C/D）
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isSelected || isCorrect == true || isWrong
                      ? borderColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + optionIndex), // A, B, C, D
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected || isCorrect == true || isWrong
                          ? Colors.white
                          : borderColor,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // 选项内容
              Expanded(
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        height: 1.5,
                      ),
                ),
              ),

              // 状态图标
              if (icon != null) ...[
                SizedBox(width: 8.w),
                Icon(
                  icon,
                  color: borderColor,
                  size: 24.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
