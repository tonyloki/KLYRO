import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/terminal_output.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;
    final verif = incident.verification;
    final isRunning = controller.isVerifying;
    final isDone = controller.currentStage == KlyroStage.verified;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Suite'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStage(KlyroStage.approvalPending),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'VERIFY STAGE',
                style: AppTypography.badge.copyWith(
                  color: isDone ? AppColors.primary : AppColors.warning,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text('TEST VERIFICATION', style: AppTypography.h2),
              const SizedBox(height: 6),
              Text(
                'Executing automated regression tests to mathematically prove bug resolution.',
                style: AppTypography.body.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Running Command Banner
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
                    Text('RUNNING COMMAND',
                        style: AppTypography.badge.copyWith(
                            color: AppColors.textMuted, fontSize: 10)),
                    const SizedBox(height: 6),
                    Text(
                      verif.testCommand,
                      style: AppTypography.codeBold.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Progress Bar
              if (isRunning) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Executing test harness...',
                            style: AppTypography.caption),
                        Text(
                          '${(controller.verificationProgress * 100).toInt()}%',
                          style: AppTypography.codeBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: controller.verificationProgress,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Before vs After Comparison Card
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
                    // Before State
                    Row(
                      children: [
                        const Icon(Icons.cancel_outlined,
                            size: 16, color: AppColors.failure),
                        const SizedBox(width: 8),
                        Text('BEFORE PATCH',
                            style: AppTypography.badge
                                .copyWith(color: AppColors.failure)),
                        const Spacer(),
                        Text('FAILED',
                            style: AppTypography.codeBold
                                .copyWith(color: AppColors.failure, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• Expected: ${verif.beforeExpected}\n• Received: ${verif.beforeReceived}',
                      style: AppTypography.codeSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const Divider(height: 24),

                    // After State
                    Row(
                      children: [
                        Icon(
                          isDone ? Icons.check_circle : Icons.hourglass_top,
                          size: 16,
                          color: isDone ? AppColors.primary : AppColors.textDim,
                        ),
                        const SizedBox(width: 8),
                        Text('AFTER PATCH',
                            style: AppTypography.badge.copyWith(
                              color: isDone ? AppColors.primary : AppColors.textMuted,
                            )),
                        const Spacer(),
                        Text(
                          isDone
                              ? '✓ ${verif.passedTests} / ${verif.totalTests} PASSED'
                              : 'PENDING',
                          style: AppTypography.codeBold.copyWith(
                            color: isDone ? AppColors.primary : AppColors.textDim,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Terminal logs
              TerminalOutputWidget(
                command: verif.testTarget,
                output: isDone ? verif.afterLog : verif.beforeLog,
                isSuccess: isDone,
              ),

              const SizedBox(height: 28),

              // Hero CTA
              if (!isDone && !isRunning)
                ElevatedButton(
                  onPressed: () {
                    controller.startVerificationTest();
                  },
                  child: const Text('RUN VERIFICATION'),
                )
              else if (isDone)
                ElevatedButton.icon(
                  onPressed: () => controller.openProofCard(),
                  icon: const Icon(Icons.workspace_premium_outlined),
                  label: const Text('GENERATE PROOF CARD'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
