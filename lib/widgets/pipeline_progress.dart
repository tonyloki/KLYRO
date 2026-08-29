import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PipelineProgressWidget extends StatelessWidget {
  final List<String> steps;
  final int activeIndex;
  final bool isCompleted;

  const PipelineProgressWidget({
    super.key,
    required this.steps,
    required this.activeIndex,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(steps.length, (index) {
          final isPast = index < activeIndex || isCompleted;
          final isCurrent = index == activeIndex && !isCompleted;

          Widget iconWidget = Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight, width: 1.5),
            ),
          );

          if (isPast) {
            iconWidget = Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.black),
            );
          } else if (isCurrent) {
            iconWidget = const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                iconWidget,
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    steps[index],
                    style: AppTypography.body.copyWith(
                      color: isPast || isCurrent
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isPast)
                  Text(
                    'DONE',
                    style: AppTypography.codeSmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                if (isCurrent)
                  Text(
                    'RUNNING',
                    style: AppTypography.codeSmall.copyWith(
                      color: AppColors.warning,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
