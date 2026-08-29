enum GraphNodeType {
  failure,
  hypothesis,
  evidence,
  reasoning,
}

class GraphNode {
  final String id;
  final String label;
  final GraphNodeType type;
  final String? subtitle;

  const GraphNode({
    required this.id,
    required this.label,
    required this.type,
    this.subtitle,
  });
}

class GraphEdge {
  final String fromId;
  final String toId;
  final String? label;
  final bool isBlocked;

  const GraphEdge({
    required this.fromId,
    required this.toId,
    this.label,
    this.isBlocked = false,
  });
}

class EvidenceSignal {
  final String title;
  final String subtitle;
  final String details;
  final bool verified;
  final String type; // code, log, git, test

  const EvidenceSignal({
    required this.title,
    required this.subtitle,
    required this.details,
    this.verified = true,
    required this.type,
  });
}

class GitCommitInfo {
  final String commitHash;
  final String author;
  final String timeAgo;
  final String message;
  final List<String> filesChanged;
  final String diffSummary;

  const GitCommitInfo({
    required this.commitHash,
    required this.author,
    required this.timeAgo,
    required this.message,
    required this.filesChanged,
    required this.diffSummary,
  });
}

class SourceSnippet {
  final String filename;
  final int startLine;
  final List<String> lines;
  final int suspiciousLineIndex; // Relative to startLine (e.g. line 42)
  final String suspiciousReason;

  const SourceSnippet({
    required this.filename,
    required this.startLine,
    required this.lines,
    required this.suspiciousLineIndex,
    required this.suspiciousReason,
  });
}
