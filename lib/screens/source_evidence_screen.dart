import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/code_viewer.dart';

class SourceEvidenceScreen extends StatelessWidget {
  const SourceEvidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Source Code Evidence'),
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
                'INSPECTION STAGE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                incident.sourceSnippet.filename,
                style: AppTypography.h2,
              ),
              const SizedBox(height: 6),
              Text(
                'AST and CFG analysis highlighted suspicious token retrieval logic.',
                style: AppTypography.body.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Code Viewer Widget
              CodeViewerWidget(
                snippet: incident.sourceSnippet,
                showSuspiciousCallout: true,
              ),

              const SizedBox(height: 20),

              // Analysis Insight Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fingerprint,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'STATIC ANALYSIS DIAGNOSIS',
                          style: AppTypography.badge.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The return statement at line ${incident.sourceSnippet.startLine + incident.sourceSnippet.suspiciousLineIndex} returns cached token without verifying TTL or expiration timestamps.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // CTA to Next Evidence or Patch
              ElevatedButton(
                onPressed: () => controller.openGitEvidence(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('CHECK GIT BLAME'),
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
