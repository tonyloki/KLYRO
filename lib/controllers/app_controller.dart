import 'dart:async';
import 'package:flutter/material.dart';
import '../data/mock_incidents.dart';
import '../models/incident.dart';
import '../models/workflow_state.dart';

enum AppViewMode {
  phoneExperience,
  officeKitDashboard,
}

class AppController extends ChangeNotifier {
  Incident _currentIncident = MockIncidents.checkoutFailureIncident;
  KlyroStage _currentStage = KlyroStage.home;
  AppViewMode _viewMode = AppViewMode.phoneExperience;
  int _analysisStepIndex = 0;
  double _verificationProgress = 0.0;
  bool _isAnalyzing = false;
  bool _isVerifying = false;
  String _selectedCaptureMode = 'Paste Log';
  String _customLogInput = '';
  int _selectedBottomNavIndex = 0;

  // Getters
  Incident get currentIncident => _currentIncident;
  KlyroStage get currentStage => _currentStage;
  AppViewMode get viewMode => _viewMode;
  int get analysisStepIndex => _analysisStepIndex;
  double get verificationProgress => _verificationProgress;
  bool get isAnalyzing => _isAnalyzing;
  bool get isVerifying => _isVerifying;
  String get selectedCaptureMode => _selectedCaptureMode;
  String get customLogInput => _customLogInput;
  int get selectedBottomNavIndex => _selectedBottomNavIndex;

  List<Incident> get allIncidents => MockIncidents.allIncidents;

  // State Transitions
  void setViewMode(AppViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setBottomNavIndex(int index) {
    _selectedBottomNavIndex = index;
    notifyListeners();
  }

  void selectIncident(Incident incident) {
    _currentIncident = incident;
    _currentStage = KlyroStage.home;
    _analysisStepIndex = 0;
    _verificationProgress = 0.0;
    _isAnalyzing = false;
    _isVerifying = false;
    notifyListeners();
  }

  void setCaptureMode(String mode) {
    _selectedCaptureMode = mode;
    notifyListeners();
  }

  void setCustomLogInput(String log) {
    _customLogInput = log;
    notifyListeners();
  }

  void navigateToStage(KlyroStage stage) {
    _currentStage = stage;
    notifyListeners();
  }

  void startIncidentCapture() {
    _currentStage = KlyroStage.captured;
    notifyListeners();
  }

  void startInvestigationAnalysis({VoidCallback? onComplete}) {
    _currentStage = KlyroStage.analyzing;
    _isAnalyzing = true;
    _analysisStepIndex = 0;
    notifyListeners();

    // Progressively step through analysis simulation
    Timer.periodic(const Duration(milliseconds: 650), (timer) {
      if (_analysisStepIndex < _currentIncident.analysisSteps.length - 1) {
        _analysisStepIndex++;
        notifyListeners();
      } else {
        timer.cancel();
        _isAnalyzing = false;
        _currentStage = KlyroStage.hypothesesReady;
        notifyListeners();
        if (onComplete != null) {
          onComplete();
        }
      }
    });
  }

  void selectHypothesisAndOpenRootCause() {
    _currentStage = KlyroStage.rootCauseFound;
    notifyListeners();
  }

  void openEvidenceView() {
    _currentStage = KlyroStage.evidenceViewed;
    notifyListeners();
  }

  void openSourceEvidence() {
    _currentStage = KlyroStage.sourceEvidence;
    notifyListeners();
  }

  void openGitEvidence() {
    _currentStage = KlyroStage.gitEvidence;
    notifyListeners();
  }

  void openGraphView() {
    _currentStage = KlyroStage.graphView;
    notifyListeners();
  }

  void openPatchReview() {
    _currentStage = KlyroStage.patchReady;
    notifyListeners();
  }

  void openApprovalDialog() {
    _currentStage = KlyroStage.approvalPending;
    notifyListeners();
  }

  void approvePatch() {
    _currentStage = KlyroStage.patchApproved;
    notifyListeners();
  }

  void startVerificationTest({VoidCallback? onComplete}) {
    _currentStage = KlyroStage.verifying;
    _isVerifying = true;
    _verificationProgress = 0.0;
    notifyListeners();

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_verificationProgress < 1.0) {
        _verificationProgress += 0.1;
        if (_verificationProgress > 1.0) _verificationProgress = 1.0;
        notifyListeners();
      } else {
        timer.cancel();
        _isVerifying = false;
        _currentStage = KlyroStage.verified;
        notifyListeners();
        if (onComplete != null) {
          onComplete();
        }
      }
    });
  }

  void openProofCard() {
    _currentStage = KlyroStage.verified;
    notifyListeners();
  }

  void resetDemo() {
    _currentStage = KlyroStage.home;
    _analysisStepIndex = 0;
    _verificationProgress = 0.0;
    _isAnalyzing = false;
    _isVerifying = false;
    _selectedCaptureMode = 'Paste Log';
    _selectedBottomNavIndex = 0;
    notifyListeners();
  }
}
