import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/hypothesis.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class InvestigateScreen extends StatelessWidget {
  const InvestigateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hypotheses Ranking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStage(KlyroStage.captured),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'HYPOTHESIZE STAGE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.warning,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('INVESTIGATION', style: AppTypography.h2),
                  Text(
                    '${incident.hypotheses.length} CANDIDATES',
                    style: AppTypography.codeSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hypotheses List
              ...incident.hypotheses.map((h) => _buildHypothesisCard(context, controller, h)),

              const SizedBox(height: 24),

              // Action Button
              ElevatedButton(
                onPressed: () => controller.selectHypothesisAndOpenRootCause(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('INVESTIGATE #1 (${incident.hypotheses.first.confidencePercentage}% CONFIDENCE)'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHypothesisCard(
    BuildContext context,
    AppController controller,
    Hypothesis h,
  ) {
    final isTop = h.isTopRanked;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isTop ? AppColors.primary : AppColors.border,
            width: isTop ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  h.id,
                  style: AppTypography.badge.copyWith(
                    color: isTop ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isTop
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isTop
                          ? AppColors.primary.withOpacity(0.5)
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    '${h.confidencePercentage}% ${isTop ? 'HIGH CONFIDENCE' : ''}',
                    style: AppTypography.badge.copyWith(
                      color: isTop ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(h.title, style: AppTypography.bodyBold.copyWith(fontSize: 15)),
            const SizedBox(height: 6),
            Text(h.description, style: AppTypography.body.copyWith(fontSize: 13)),

            if (isTop) ...[
              const Divider(height: 24),
              Text(
                'HEURISTIC WEIGHTS BREAKDOWN',
                style: AppTypography.badge.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: h.breakdown.toMap().entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      '${entry.key} +${entry.value}',
                      style: AppTypography.codeSmall.copyWith(
                        color: AppColors.primary,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
