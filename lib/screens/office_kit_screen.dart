import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/terminal_output.dart';

class OfficeKitScreen extends StatelessWidget {
  const OfficeKitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;
    final isPatchApproved = controller.currentStage.index >= KlyroStage.patchApproved.index;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.laptop_chromebook, size: 20, color: AppColors.info),
            const SizedBox(width: 8),
            Text('KLYRO OFFICE KIT', style: AppTypography.h3),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'SYNCED',
                  style: AppTypography.badge.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Incident ID & Title
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
                      'INCIDENT #${incident.id}',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(incident.title, style: AppTypography.h2),
                    const SizedBox(height: 4),
                    Text(
                      incident.failureName,
                      style: AppTypography.codeSmall.copyWith(
                        color: AppColors.failure,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Execution Surface Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Repository: ${incident.project}',
                            style: AppTypography.codeBold.copyWith(fontSize: 12)),
                        const Icon(Icons.hub, size: 16, color: AppColors.primary),
                      ],
                    ),
                    const Divider(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _buildStatusIndicator('AST Indexed', true),
                        _buildStatusIndicator('Git Head Clean', true),
                        _buildStatusIndicator('Test Runner Ready', true),
                        _buildStatusIndicator('Local AI Engine Ready', true),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Execution Timeline
              Text(
                'TIMELINE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              _buildTimelineStep('Incident received from mobile client', true),
              _buildTimelineStep('Evidence signals parsed & AST indexed', true),
              _buildTimelineStep('Repository blame & commit diff correlated', true),
              _buildTimelineStep('Diagnosis & patch generated', true),
              _buildTimelineStep(
                  'Human patch approval received from phone', isPatchApproved),
              _buildTimelineStep(
                  'Verification test suite executed on workspace',
                  controller.currentStage == KlyroStage.verified),

              const SizedBox(height: 24),

              // Simulated Terminal
              TerminalOutputWidget(
                command: incident.verification.testCommand,
                output: isPatchApproved
                    ? incident.verification.afterLog
                    : incident.verification.beforeLog,
                isSuccess: isPatchApproved,
              ),

              const SizedBox(height: 28),

              // Action
              if (controller.currentStage != KlyroStage.verified)
                ElevatedButton(
                  onPressed: () {
                    controller.startVerificationTest();
                  },
                  child: const Text('RUN VERIFICATION TEST'),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => controller.openProofCard(),
                  icon: const Icon(Icons.verified),
                  label: const Text('VIEW PROOF CARD'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isOnline) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? AppColors.primary : AppColors.failure,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String title, bool isComplete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isComplete ? AppColors.primary : AppColors.textDim,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: AppTypography.body.copyWith(
                fontSize: 12,
                color: isComplete
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
