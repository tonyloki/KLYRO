import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/diff_viewer.dart';

class PatchScreen extends StatelessWidget {
  const PatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;
    final patch = incident.patch;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposed Patch'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStage(KlyroStage.evidenceViewed),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'REPAIR STAGE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text('PROPOSED REPAIR', style: AppTypography.h2),
              const SizedBox(height: 16),

              // Unified Diff Viewer Widget
              DiffViewerWidget(
                diffLines: patch.diffLines,
                filename: patch.filename,
              ),

              const SizedBox(height: 20),

              // Why / Rationale Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHY THIS CHANGE?',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      patch.whyExplanation,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),

                    const Divider(height: 24),

                    // Risk & File stats
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RISK LEVEL',
                                style: AppTypography.badge.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  patch.riskLevel.name.toUpperCase(),
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FILES AFFECTED',
                                style: AppTypography.badge.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${patch.filesAffected} file (${patch.additions} additions, ${patch.deletions} deletions)',
                                style: AppTypography.codeSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Action Buttons: Reject & Approve Patch
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Patch rejected. Exploring alternative hypotheses.'),
                          ),
                        );
                        controller.navigateToStage(KlyroStage.hypothesesReady);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.failure,
                        side: const BorderSide(color: AppColors.failure),
                      ),
                      child: const Text('REJECT'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => controller.openApprovalDialog(),
                      child: const Text('APPROVE PATCH'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
