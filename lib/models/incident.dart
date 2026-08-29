import 'evidence.dart';
import 'hypothesis.dart';
import 'patch.dart';
import 'verification.dart';
import 'workflow_state.dart';

class Incident {
  final String id;
  final String title;
  final String project;
  final IncidentType type;
  final String failureName;
  final String failureDetail;
  final IncidentStatus status;
  final String detectedFile;
  final int detectedLine;
  final List<String> capturedEvidenceTags;
  final List<String> analysisSteps;
  final List<Hypothesis> hypotheses;
  final String rootCauseTitle;
  final String rootCauseDescription;
  final int confidence;
  final List<String> failurePathNodes;
  final List<EvidenceSignal> evidenceSignals;
  final SourceSnippet sourceSnippet;
  final GitCommitInfo gitCommitInfo;
  final List<GraphNode> graphNodes;
  final List<GraphEdge> graphEdges;
  final PatchProposal patch;
  final VerificationResult verification;

  const Incident({
    required this.id,
    required this.title,
    required this.project,
    required this.type,
    required this.failureName,
    required this.failureDetail,
    required this.status,
    required this.detectedFile,
    required this.detectedLine,
    required this.capturedEvidenceTags,
    required this.analysisSteps,
    required this.hypotheses,
    required this.rootCauseTitle,
    required this.rootCauseDescription,
    required this.confidence,
    required this.failurePathNodes,
    required this.evidenceSignals,
    required this.sourceSnippet,
    required this.gitCommitInfo,
    required this.graphNodes,
    required this.graphEdges,
    required this.patch,
    required this.verification,
  });
}
