import 'package:flutter/material.dart';
import '../models/evidence.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CodeViewerWidget extends StatelessWidget {
  final SourceSnippet snippet;
  final bool showSuspiciousCallout;

  const CodeViewerWidget({
    super.key,
    required this.snippet,
    this.showSuspiciousCallout = true,
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
          // Header Tab
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  snippet.filename,
                  style: AppTypography.codeBold.copyWith(fontSize: 12),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    'UTF-8',
                    style: AppTypography.caption.copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),

          // Lines
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(snippet.lines.length, (index) {
                final lineNumber = snippet.startLine + index;
                final isSuspicious = index == snippet.suspiciousLineIndex;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      color: isSuspicious
                          ? AppColors.codeSuspiciousBg
                          : Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Line Number
                          SizedBox(
                            width: 32,
                            child: Text(
                              '$lineNumber',
                              style: AppTypography.codeSmall.copyWith(
                                color: isSuspicious
                                    ? AppColors.warning
                                    : AppColors.textMuted,
                                fontWeight: isSuspicious
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          // Vertical border separator
                          Container(
                            width: 1,
                            height: 18,
                            color: isSuspicious
                                ? AppColors.codeSuspiciousBorder
                                : AppColors.border,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          // Code text
                          Expanded(
                            child: Text(
                              snippet.lines[index],
                              style: AppTypography.code.copyWith(
                                color: isSuspicious
                                    ? AppColors.warning
                                    : AppColors.textPrimary,
                                fontWeight: isSuspicious
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSuspicious && showSuspiciousCallout)
                      Padding(
                        padding: const EdgeInsets.only(left: 48, right: 12, top: 4, bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF261D10),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.warning, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 14, color: AppColors.warning),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  snippet.suspiciousReason,
                                  style: AppTypography.codeSmall.copyWith(
                                    color: AppColors.warning,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
