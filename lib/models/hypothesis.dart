class HeuristicBreakdown {
  final int stackTraceWeight;
  final int dependencyPathWeight;
  final int recentChangeWeight;
  final int logMatchWeight;
  final int testOverlapWeight;
  final int modelPriorWeight;

  const HeuristicBreakdown({
    this.stackTraceWeight = 30,
    this.dependencyPathWeight = 20,
    this.recentChangeWeight = 20,
    this.logMatchWeight = 15,
    this.testOverlapWeight = 10,
    this.modelPriorWeight = 5,
  });

  Map<String, int> toMap() => {
        'Stack trace': stackTraceWeight,
        'Dependency path': dependencyPathWeight,
        'Recent change': recentChangeWeight,
        'Log match': logMatchWeight,
        'Test overlap': testOverlapWeight,
        'Model prior': modelPriorWeight,
      };
}

class Hypothesis {
  final String id;
  final String title;
  final String description;
  final int confidencePercentage; // e.g. 91
  final bool isTopRanked;
  final HeuristicBreakdown breakdown;

  const Hypothesis({
    required this.id,
    required this.title,
    required this.description,
    required this.confidencePercentage,
    this.isTopRanked = false,
    this.breakdown = const HeuristicBreakdown(),
  });
}
