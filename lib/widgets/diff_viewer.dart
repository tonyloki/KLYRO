import 'package:flutter/material.dart';
import '../models/patch.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class DiffViewerWidget extends StatelessWidget {
  final List<PatchLine> diffLines;
  final String filename;

  const DiffViewerWidget({
    super.key,
    required this.diffLines,
    required this.filename,
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
          // File header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.difference_outlined,
                    size: 16, color: AppColors.info),
                const SizedBox(width: 8),
                Text(
                  filename,
                  style: AppTypography.codeBold.copyWith(fontSize: 12),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.diffAddBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+${diffLines.where((l) => l.isAdded).length}',
                    style: AppTypography.codeSmall
                        .copyWith(color: AppColors.primary, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.diffRemoveBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${diffLines.where((l) => l.isRemoved).length}',
                    style: AppTypography.codeSmall
                        .copyWith(color: AppColors.failure, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          // Diff content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: diffLines.map((line) {
                Color? bg;
                Color textColor = AppColors.textSecondary;
                Color borderIndicator = Colors.transparent;

                if (line.isAdded) {
                  bg = AppColors.diffAddBg;
                  textColor = AppColors.primary;
                  borderIndicator = AppColors.diffAddBorder;
                } else if (line.isRemoved) {
                  bg = AppColors.diffRemoveBg;
                  textColor = AppColors.failure;
                  borderIndicator = AppColors.diffRemoveBorder;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: bg,
                    border: Border(
                      left: BorderSide(color: borderIndicator, width: 3),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: Text(
                    line.text,
                    style: AppTypography.code.copyWith(
                      color: textColor,
                      fontWeight: line.isAdded || line.isRemoved
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
