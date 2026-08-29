import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../data/mock_incidents.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Brand & Local Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text('KLYRO', style: AppTypography.h1.copyWith(fontSize: 22)),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
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
                          'LOCAL',
                          style: AppTypography.badge.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Software & RTL Diagnostic Intelligence',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 28),

              // Active Incidents Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ACTIVE INCIDENTS',
                    style: AppTypography.badge.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    '${controller.allIncidents.length} TOTAL',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Incident List Cards
              ...controller.allIncidents.map((inc) {
                final isSelected = controller.currentIncident.id == inc.id;
                final isVerif = inc.status == IncidentStatus.verified;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      controller.selectIncident(inc);
                      controller.startIncidentCapture();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.6)
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isVerif
                                  ? AppColors.primary
                                  : AppColors.failure,
                              boxShadow: [
                                BoxShadow(
                                  color: (isVerif
                                          ? AppColors.primary
                                          : AppColors.failure)
                                      .withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        inc.title,
                                        style: AppTypography.bodyBold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceElevated,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        inc.type == IncidentType.softwareAndroid
                                            ? 'ANDROID'
                                            : 'VERILOG RTL',
                                        style: AppTypography.caption.copyWith(
                                          fontSize: 9,
                                          color: inc.type ==
                                                  IncidentType.softwareAndroid
                                              ? AppColors.info
                                              : AppColors.ai,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  inc.failureName,
                                  style: AppTypography.codeSmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isVerif ? 'Verified' : 'Investigating',
                                style: AppTypography.caption.copyWith(
                                  color: isVerif
                                      ? AppColors.primary
                                      : AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // + New Incident Button
              ElevatedButton.icon(
                onPressed: () {
                  controller.selectIncident(MockIncidents.checkoutFailureIncident);
                  controller.startIncidentCapture();
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ New Incident'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.borderLight),
                ),
              ),

              const SizedBox(height: 28),

              // Bottom Stats Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hub_outlined,
                            size: 16, color: AppColors.ai),
                        const SizedBox(width: 8),
                        Text(
                          'KLYRO DIAGNOSTIC ENGINE',
                          style: AppTypography.badge.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'AI proposes. Tools prove.',
                      style: AppTypography.bodyBold.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Automated correlation of stack traces, Git blame, test vectors, and AST dependency graphs into verifiable root causes.',
                      style: AppTypography.caption.copyWith(height: 1.4),
                    ),
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
