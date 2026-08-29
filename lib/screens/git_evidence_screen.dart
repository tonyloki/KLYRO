import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class GitEvidenceScreen extends StatelessWidget {
  const GitEvidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;
    final git = incident.gitCommitInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Correlation'),
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
                'CORRELATION STAGE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.warning,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text('RECENT CHANGE', style: AppTypography.h2),
              const SizedBox(height: 16),

              // Commit Info Card
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
                    Row(
                      children: [
                        const Icon(Icons.commit,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'commit ${git.commitHash}',
                          style: AppTypography.codeBold.copyWith(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          git.timeAgo,
                          style: AppTypography.caption.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"${git.message}"',
                      style: AppTypography.bodyBold.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Author: ${git.author}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const Divider(height: 24),

                    Text(
                      'FILES CHANGED (${git.filesChanged.length})',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...git.filesChanged.map(
                      (f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined,
                                size: 14, color: AppColors.info),
                            const SizedBox(width: 8),
                            Text(f, style: AppTypography.codeSmall),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 24),

                    Text(
                      'DIFF SUMMARY',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.codeBackground,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        git.diffSummary,
                        style: AppTypography.codeSmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Correlation Warning Callout
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF261D10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 20, color: AppColors.warning),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HIGH CORRELATION DETECTED',
                            style: AppTypography.badge.copyWith(
                              color: AppColors.warning,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Change correlates directly with the observed failure timeline and call stack.',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Actions
              ElevatedButton(
                onPressed: () => controller.openGraphView(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('VIEW EVIDENCE GRAPH'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
