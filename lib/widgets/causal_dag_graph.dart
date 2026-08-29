import 'package:flutter/material.dart';
import '../models/evidence.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CausalDagGraphWidget extends StatelessWidget {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final Function(GraphNode)? onNodeTap;

  const CausalDagGraphWidget({
    super.key,
    required this.nodes,
    required this.edges,
    this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Legend Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendDot('Failure', AppColors.failure),
              _buildLegendDot('Evidence', AppColors.primary),
              _buildLegendDot('Hypothesis', AppColors.warning),
              _buildLegendDot('AI Reasoning', AppColors.ai),
            ],
          ),
          const SizedBox(height: 20),

          // Render Nodes Vertically with Animated Connections
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nodes.length,
            separatorBuilder: (context, index) {
              final currentNode = nodes[index];
              final nextNode = (index + 1 < nodes.length) ? nodes[index + 1] : null;

              // Find edge label if exists
              String edgeLabel = 'leads to';
              bool isBlocked = false;
              if (nextNode != null) {
                final matchingEdges = edges.where((e) =>
                    e.fromId == currentNode.id && e.toId == nextNode.id);
                if (matchingEdges.isNotEmpty) {
                  edgeLabel = matchingEdges.first.label ?? 'leads to';
                  isBlocked = matchingEdges.first.isBlocked;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 12,
                        width: 1.5,
                        color: isBlocked ? AppColors.failure : AppColors.borderLight,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isBlocked ? AppColors.failure : AppColors.border,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBlocked) ...[
                              const Icon(Icons.close, size: 10, color: AppColors.failure),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              edgeLabel,
                              style: AppTypography.caption.copyWith(
                                fontSize: 10,
                                color: isBlocked
                                    ? AppColors.failure
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 12,
                        width: 1.5,
                        color: isBlocked ? AppColors.failure : AppColors.borderLight,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: isBlocked ? AppColors.failure : AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              );
            },
            itemBuilder: (context, index) {
              final node = nodes[index];
              final color = _getNodeColor(node.type);

              return InkWell(
                onTap: onNodeTap != null ? () => onNodeTap!(node) : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.5), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.label,
                              style: AppTypography.bodyBold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (node.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                node.subtitle!,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          node.type.name.toUpperCase(),
                          style: AppTypography.badge.copyWith(
                            color: color,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getNodeColor(GraphNodeType type) {
    switch (type) {
      case GraphNodeType.failure:
        return AppColors.failure;
      case GraphNodeType.evidence:
        return AppColors.primary;
      case GraphNodeType.hypothesis:
        return AppColors.warning;
      case GraphNodeType.reasoning:
        return AppColors.ai;
    }
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
