import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/audio_wave_capture.dart';

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Incident'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStage(KlyroStage.home),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'OBSERVE STAGE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'How do you want to capture the failure?',
                style: AppTypography.h2,
              ),
              const SizedBox(height: 20),

              // 4 Capture Mode Buttons Grid
              Row(
                children: [
                  Expanded(
                    child: _buildCaptureOption(
                      context,
                      icon: Icons.screenshot_monitor,
                      label: 'Screenshot',
                      isSelected: controller.selectedCaptureMode == 'Screenshot',
                      onTap: () => controller.setCaptureMode('Screenshot'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildCaptureOption(
                      context,
                      icon: Icons.paste_outlined,
                      label: 'Paste Log',
                      isSelected: controller.selectedCaptureMode == 'Paste Log',
                      onTap: () => controller.setCaptureMode('Paste Log'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildCaptureOption(
                      context,
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      isSelected: controller.selectedCaptureMode == 'Camera',
                      onTap: () => controller.setCaptureMode('Camera'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildCaptureOption(
                      context,
                      icon: Icons.mic_none_outlined,
                      label: 'Voice',
                      isSelected: controller.selectedCaptureMode == 'Voice',
                      onTap: () => controller.setCaptureMode('Voice'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dynamic Interactive Area based on selected mode
              if (controller.selectedCaptureMode == 'Voice') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.ai.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.failure,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('RECORDING AUDIO EVIDENCE',
                              style: AppTypography.badge
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const AudioWaveCaptureWidget(isRecording: true),
                      const SizedBox(height: 8),
                      Text(
                        '"Checkout keeps failing with 401 even after the user logged in 5 minutes ago..."',
                        style: AppTypography.codeSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Captured Evidence Card
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
                        const Icon(Icons.check_circle_outline,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Captured Evidence',
                          style: AppTypography.bodyBold,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DETECTED',
                            style: AppTypography.badge.copyWith(
                              color: AppColors.primary,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...incident.capturedEvidenceTags.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Text('› ',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                tag,
                                style: AppTypography.codeSmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Create Incident Action Button
              ElevatedButton(
                onPressed: () {
                  controller.startInvestigationAnalysis();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('CREATE INCIDENT'),
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

  Widget _buildCaptureOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.bodyBold.copyWith(
                fontSize: 12,
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
