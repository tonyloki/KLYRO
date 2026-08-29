import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/workflow_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/causal_dag_graph.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final incident = controller.currentIncident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidence DAG Graph'),
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
                'CAUSAL REASONING GRAPH',
                style: AppTypography.badge.copyWith(
                  color: AppColors.ai,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text('Evidence Relationships', style: AppTypography.h2),
              const SizedBox(height: 6),
              Text(
                'Interactive DAG linking observed telemetry to the root mechanism.',
                style: AppTypography.body.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // The Causal Graph Widget
              CausalDagGraphWidget(
                nodes: incident.graphNodes,
                edges: incident.graphEdges,
                onNodeTap: (node) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.surfaceElevated,
                      content: Text(
                        'Node: ${node.label} (${node.type.name.toUpperCase()})',
                        style: AppTypography.codeSmall,
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // Action to Patch
              ElevatedButton(
                onPressed: () => controller.openPatchReview(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('PROPOSE REPAIR PATCH'),
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
