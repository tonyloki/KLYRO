enum KlyroStage {
  home,
  captured,
  analyzing,
  hypothesesReady,
  rootCauseFound,
  evidenceViewed,
  sourceEvidence,
  gitEvidence,
  graphView,
  patchReady,
  approvalPending,
  patchApproved,
  verifying,
  verified,
}

enum IncidentStatus {
  investigating,
  patchReady,
  verified,
  failed,
}

enum RiskLevel {
  low,
  medium,
  high,
}

enum IncidentType {
  softwareAndroid,
  hardwareVerilogRTL,
}
