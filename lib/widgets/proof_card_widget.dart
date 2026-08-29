import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ProofCardWidget extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onShare;

  const ProofCardWidget({
    super.key,
    required this.incident,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      'KLYRO PROOF CARD',
                      style: AppTypography.badge.copyWith(
                        letterSpacing: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'VERIFIED',
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
          ),

          // Incident info
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident.title.toUpperCase(),
                  style: AppTypography.h3.copyWith(
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  incident.failureName,
                  style: AppTypography.codeBold.copyWith(
                    color: AppColors.failure,
                    fontSize: 13,
                  ),
                ),

                const Divider(height: 24),

                // Root Cause
                _buildSectionHeader('ROOT CAUSE'),
                const SizedBox(height: 6),
                Text(
                  incident.rootCauseTitle,
                  style: AppTypography.bodyBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // Confidence
                Row(
                  children: [
                    _buildSectionHeader('CONFIDENCE'),
                    const Spacer(),
                    Text(
                      '${incident.confidence}%',
                      style: AppTypography.codeBold.copyWith(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Evidence signals
                _buildSectionHeader('EVIDENCE SIGNALS'),
                const SizedBox(height: 8),
                ...incident.evidenceSignals.take(4).map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.title,
                                style: AppTypography.codeSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                const Divider(height: 24),

                // Repair & Verification Metrics
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('REPAIR'),
                          const SizedBox(height: 4),
                          Text(
                            '${incident.patch.filesAffected} file changed',
                            style: AppTypography.codeSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '+${incident.patch.additions} / -${incident.patch.deletions} lines',
                            style: AppTypography.caption.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('VERIFICATION'),
                          const SizedBox(height: 4),
                          Text(
                            '${incident.verification.passedTests} / ${incident.verification.totalTests} tests passed',
                            style: AppTypography.codeSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '100% regression free',
                            style: AppTypography.caption.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 28),

                // Tagline Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'KLYRO',
                        style: AppTypography.badge.copyWith(
                          color: AppColors.textPrimary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Don't guess the bug. Prove the cause.",
                        style: AppTypography.body.copyWith(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.badge.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1.0,
        fontSize: 10,
      ),
    );
  }
}
