import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/pipeline_progress.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;
    final isDone = controller.currentStage == KlyroStage.hypothesesReady;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? AppColors.primary : AppColors.warning,
                          width: 1.5,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 28, color: AppColors.primary)
                          : const Icon(Icons.analytics_outlined,
                              size: 28, color: AppColors.warning),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isDone ? 'ANALYSIS COMPLETE' : 'KLYRO IS INVESTIGATING',
                      style: AppTypography.h2.copyWith(letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isDone
                          ? '${incident.hypotheses.length} hypotheses ranked'
                          : 'Correlating runtime telemetry with repository AST...',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Step By Step Progress Widget
              PipelineProgressWidget(
                steps: incident.analysisSteps,
                activeIndex: controller.analysisStepIndex,
                isCompleted: isDone,
              ),

              const Spacer(),

              // Completion Action
              if (isDone) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${incident.hypotheses.length} hypotheses identified with ${incident.confidence}% top confidence.',
                          style: AppTypography.codeSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.navigateToStage(KlyroStage.hypothesesReady);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('VIEW HYPOTHESES'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
