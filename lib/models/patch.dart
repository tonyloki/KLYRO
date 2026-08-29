import 'workflow_state.dart';

class PatchLine {
  final String text;
  final bool isAdded;
  final bool isRemoved;

  const PatchLine({
    required this.text,
    this.isAdded = false,
    this.isRemoved = false,
  });
}

class PatchProposal {
  final String filename;
  final List<PatchLine> diffLines;
  final String whyExplanation;
  final RiskLevel riskLevel;
  final int filesAffected;
  final int additions;
  final int deletions;
  final String commitMessage;

  const PatchProposal({
    required this.filename,
    required this.diffLines,
    required this.whyExplanation,
    this.riskLevel = RiskLevel.low,
    this.filesAffected = 1,
    this.additions = 3,
    this.deletions = 1,
    required this.commitMessage,
  });
}
