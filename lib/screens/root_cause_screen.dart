import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RootCauseScreen extends StatelessWidget {
  const RootCauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Root Cause Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStage(KlyroStage.hypothesesReady),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Signature Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ROOT CAUSE',
                          style: AppTypography.badge.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Text(
                            '${incident.confidence}% CONFIDENCE',
                            style: AppTypography.badge.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      incident.rootCauseTitle,
                      style: AppTypography.h2.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      incident.rootCauseDescription,
                      style: AppTypography.body.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Failure Path Section
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'FAILURE PATH',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Failure Path Steps Visual Flow
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: List.generate(incident.failurePathNodes.length, (index) {
                    final node = incident.failurePathNodes[index];
                    final isLast = index == incident.failurePathNodes.length - 1;
                    final isCulprit = index == 3; // e.g. TokenCache or missing carry

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isCulprit
                                ? AppColors.codeSuspiciousBg
                                : (isLast
                                    ? AppColors.diffRemoveBg
                                    : AppColors.surfaceElevated),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCulprit
                                  ? AppColors.warning
                                  : (isLast
                                      ? AppColors.failure
                                      : AppColors.borderLight),
                              width: isCulprit || isLast ? 1.2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '0${index + 1}',
                                style: AppTypography.codeSmall.copyWith(
                                  color: isCulprit
                                      ? AppColors.warning
                                      : AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  node,
                                  style: AppTypography.bodyBold.copyWith(
                                    color: isCulprit
                                        ? AppColors.warning
                                        : (isLast
                                            ? AppColors.failure
                                            : AppColors.textPrimary),
                                  ),
                                ),
                              ),
                              if (isCulprit)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'CULPRIT',
                                    style: AppTypography.badge.copyWith(
                                      color: AppColors.warning,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              if (isLast)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.failure.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'FAILURE',
                                    style: AppTypography.badge.copyWith(
                                      color: AppColors.failure,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Icon(
                              Icons.arrow_downward,
                              size: 16,
                              color: isCulprit
                                  ? AppColors.warning
                                  : AppColors.textDim,
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // Supporting signals counter badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${incident.evidenceSignals.length} supporting signals verified',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Actions
              ElevatedButton(
                onPressed: () => controller.openEvidenceView(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('VIEW EVIDENCE'),
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
