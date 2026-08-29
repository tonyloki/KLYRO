import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'analysis_screen.dart';
import 'approval_screen.dart';
import 'capture_screen.dart';
import 'evidence_screen.dart';
import 'git_evidence_screen.dart';
import 'graph_screen.dart';
import 'home_screen.dart';
import 'investigate_screen.dart';
import 'office_kit_screen.dart';
import 'patch_screen.dart';
import 'proof_card_screen.dart';
import 'root_cause_screen.dart';
import 'source_evidence_screen.dart';
import 'verification_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Row(
              children: [
                // Mode Toggle Button (Phone vs Office Kit)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      _buildModeSegment(
                        label: '📱 PHONE',
                        isSelected:
                            controller.viewMode == AppViewMode.phoneExperience,
                        onTap: () =>
                            controller.setViewMode(AppViewMode.phoneExperience),
                      ),
                      _buildModeSegment(
                        label: '💻 OFFICE KIT',
                        isSelected: controller.viewMode ==
                            AppViewMode.officeKitDashboard,
                        onTap: () => controller
                            .setViewMode(AppViewMode.officeKitDashboard),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Incident Selector Menu
                PopupMenuButton<String>(
                  color: AppColors.surfaceElevated,
                  icon: const Icon(Icons.tune, size: 20, color: AppColors.textSecondary),
                  tooltip: 'Switch Debug Case',
                  onSelected: (caseId) {
                    final selected = controller.allIncidents.firstWhere(
                      (i) => i.id == caseId,
                      orElse: () => controller.allIncidents.first,
                    );
                    controller.selectIncident(selected);
                  },
                  itemBuilder: (context) {
                    return controller.allIncidents.map((inc) {
                      return PopupMenuItem<String>(
                        value: inc.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(inc.title, style: AppTypography.bodyBold),
                            Text(
                              '${inc.id} • ${inc.project}',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
                // Quick Reset Button
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20, color: AppColors.textMuted),
                  tooltip: 'Reset Demo Flow',
                  onPressed: () => controller.resetDemo(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildCurrentView(controller),
      ),
      bottomNavigationBar: controller.viewMode == AppViewMode.phoneExperience
          ? BottomNavigationBar(
              currentIndex: controller.selectedBottomNavIndex,
              onTap: (index) {
                controller.setBottomNavIndex(index);
                if (index == 0) {
                  controller.navigateToStage(KlyroStage.home);
                } else if (index == 1) {
                  controller.navigateToStage(KlyroStage.captured);
                } else if (index == 2) {
                  controller.navigateToStage(KlyroStage.evidenceViewed);
                } else if (index == 3) {
                  controller.navigateToStage(KlyroStage.verified);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bug_report_outlined),
                  activeIcon: Icon(Icons.bug_report),
                  label: 'Capture',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield_outlined),
                  activeIcon: Icon(Icons.shield),
                  label: 'Evidence',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.verified_outlined),
                  activeIcon: Icon(Icons.verified),
                  label: 'Proof Card',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildModeSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: AppTypography.badge.copyWith(
            color: isSelected ? Colors.black : AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView(AppController controller) {
    if (controller.viewMode == AppViewMode.officeKitDashboard) {
      return const OfficeKitScreen();
    }

    switch (controller.currentStage) {
      case KlyroStage.home:
        return const HomeScreen();
      case KlyroStage.captured:
        return const CaptureScreen();
      case KlyroStage.analyzing:
        return const AnalysisScreen();
      case KlyroStage.hypothesesReady:
        return const InvestigateScreen();
      case KlyroStage.rootCauseFound:
        return const RootCauseScreen();
      case KlyroStage.evidenceViewed:
        return const EvidenceScreen();
      case KlyroStage.sourceEvidence:
        return const SourceEvidenceScreen();
      case KlyroStage.gitEvidence:
        return const GitEvidenceScreen();
      case KlyroStage.graphView:
        return const GraphScreen();
      case KlyroStage.patchReady:
        return const PatchScreen();
      case KlyroStage.approvalPending:
      case KlyroStage.patchApproved:
        return const ApprovalScreen();
      case KlyroStage.verifying:
        return const VerificationScreen();
      case KlyroStage.verified:
        return const ProofCardScreen();
    }
  }
}
