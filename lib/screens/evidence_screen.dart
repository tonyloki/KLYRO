import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/evidence.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class EvidenceScreen extends StatelessWidget {
  const EvidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidence Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.navigateToStage(KlyroStage.rootCauseFound),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PROVE STAGE',
                style: AppTypography.badge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'WHY ${incident.detectedFile.toUpperCase()}?',
                style: AppTypography.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'Corroborating deterministic signals across runtime, AST, Git blame, and test execution.',
                style: AppTypography.body.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Drilldown Quick Navigation Bar
              Row(
                children: [
                  Expanded(
                    child: _buildDrilldownButton(
                      icon: Icons.code,
                      label: 'Source',
                      color: AppColors.primary,
                      onTap: () => controller.openSourceEvidence(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDrilldownButton(
                      icon: Icons.history,
                      label: 'Git Blame',
                      color: AppColors.warning,
                      onTap: () => controller.openGitEvidence(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDrilldownButton(
                      icon: Icons.account_tree_outlined,
                      label: 'DAG Graph',
                      color: AppColors.ai,
                      onTap: () => controller.openGraphView(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Expandable Evidence Signals
              ...incident.evidenceSignals.map((signal) => _buildSignalCard(context, signal)),

              const SizedBox(height: 28),

              // CTA to Patch
              ElevatedButton(
                onPressed: () => controller.openPatchReview(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('PREPARE REPAIR'),
                    SizedBox(width: 8),
                    Icon(Icons.build_circle_outlined, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrilldownButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.codeSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalCard(BuildContext context, EvidenceSignal signal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: signal.type == 'code',
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
              child: const Icon(Icons.check, size: 14, color: AppColors.primary),
            ),
            title: Text(
              signal.title,
              style: AppTypography.bodyBold.copyWith(fontSize: 13),
            ),
            subtitle: Text(
              signal.subtitle,
              style: AppTypography.caption.copyWith(fontSize: 11),
            ),
            childrenPadding:
                const EdgeInsets.fromLTRB(14, 0, 14, 12),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.codeBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  signal.details,
                  style: AppTypography.codeSmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
