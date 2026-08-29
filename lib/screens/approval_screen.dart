import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;
    final patch = incident.patch;
    final isApproved = controller.currentStage == KlyroStage.patchApproved;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Human Approval Gate'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => controller.navigateToStage(KlyroStage.patchReady),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Security Shield Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isApproved ? AppColors.primary : AppColors.ai,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isApproved ? Icons.verified_user : Icons.lock_outline,
                    size: 36,
                    color: isApproved ? AppColors.primary : AppColors.ai,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  isApproved ? 'PATCH APPROVED' : 'APPROVE REPAIR?',
                  style: AppTypography.h2,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isApproved
                      ? 'Temporal signal dispatched to execution worker.'
                      : 'You are authorizing an in-place code patch on the execution surface.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 28),

              // Summary Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildApprovalRow('Target File', patch.filename, isCode: true),
                    const Divider(height: 20),
                    _buildApprovalRow('Files Affected', '${patch.filesAffected} file'),
                    const Divider(height: 20),
                    _buildApprovalRow('Modifications',
                        '+${patch.additions} additions, -${patch.deletions} deletions'),
                    const Divider(height: 20),
                    _buildApprovalRow('Risk Assessment', patch.riskLevel.name.toUpperCase(),
                        color: AppColors.primary),
                    const Divider(height: 20),
                    _buildApprovalRow('Rollback Safety', 'Git commit can be reverted',
                        color: AppColors.info),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              if (!isApproved) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            controller.navigateToStage(KlyroStage.patchReady),
                        child: const Text('CANCEL'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.approvePatch();
                        },
                        child: const Text('CONFIRM APPROVAL'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    controller.startVerificationTest();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('RUN VERIFICATION TEST'),
                      SizedBox(width: 8),
                      Icon(Icons.play_arrow, size: 20),
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

  Widget _buildApprovalRow(String label, String value,
      {bool isCode = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body),
        Text(
          value,
          style: isCode
              ? AppTypography.codeBold.copyWith(color: color ?? AppColors.textPrimary)
              : AppTypography.bodyBold.copyWith(color: color ?? AppColors.textPrimary),
        ),
      ],
    );
  }
}
