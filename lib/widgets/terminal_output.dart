import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TerminalOutputWidget extends StatelessWidget {
  final String command;
  final String output;
  final bool isSuccess;

  const TerminalOutputWidget({
    super.key,
    required this.command,
    required this.output,
    this.isSuccess = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.failure,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'bash ~ execution surface',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),

          // Command Line
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$ ',
                  style: AppTypography.codeBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    command,
                    style: AppTypography.code.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stdout text
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              output,
              style: AppTypography.codeSmall.copyWith(
                color: isSuccess ? AppColors.textSecondary : AppColors.failure,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
