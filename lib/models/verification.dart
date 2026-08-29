class VerificationResult {
  final String testCommand;
  final String testTarget;
  final String beforeStatus;
  final String beforeExpected;
  final String beforeReceived;
  final String beforeLog;
  final String afterStatus;
  final int totalTests;
  final int passedTests;
  final String afterLog;

  const VerificationResult({
    required this.testCommand,
    required this.testTarget,
    required this.beforeStatus,
    required this.beforeExpected,
    required this.beforeReceived,
    required this.beforeLog,
    required this.afterStatus,
    required this.totalTests,
    required this.passedTests,
    required this.afterLog,
  });
}
