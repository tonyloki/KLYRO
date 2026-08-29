# ⚡ KLYRO — Diagnostic Intelligence System (Flutter Android)

> **"AI proposes. Tools prove."**  
> *"Don't guess the bug. Prove the cause."*

KLYRO is a phone-first software & hardware diagnostic intelligence application built in Flutter for Android. It turns complex runtime failures (such as mobile auth crashes or Verilog RTL verification assertion errors) into evidence-backed root causes, code repairs, and mathematically verified test results.

---

## 📱 14-Screen Prototype Architecture

This application implements the 14 core prototype screens specified in the **KLYRO Prototype Plan**:

```
[ 01. HOME ] ────────────► [ 02. CAPTURE ] ────────────► [ 03. ANALYZING ]
     │                              │                               │
     ▼                              ▼                               ▼
[ 06. EVIDENCE ] ◄─────── [ 05. ROOT CAUSE ] ◄────────── [ 04. INVESTIGATE ]
     │ (Drilldowns)
     ├─► [ 07. SOURCE CODE ] (TokenCache.kt / alu.v)
     ├─► [ 08. GIT BLAME ]   (Commit a81c2d1 correlation)
     └─► [ 09. DAG GRAPH ]   (Interactive Causal Flow)
     │
     ▼
[ 10. PATCH REVIEW ] ────► [ 11. APPROVAL GATE ] ───────► [ 12. OFFICE KIT ]
                                    │                               │
                                    ▼                               ▼
                           [ 14. PROOF CARD ] ◄────────── [ 13. VERIFICATION ]
```

### Screen Breakdown
1. **Screen 01 — Home**: Active incident feed, local intelligence status (`⚡ KLYRO ◉ LOCAL`), and quick incident initiation.
2. **Screen 02 — Capture**: Multi-modal failure intake (Screenshot, Paste Log, Camera, Voice audio waveform recording).
3. **Screen 03 — Analysis Loading**: Progressive diagnostic pipeline animation (`Failure parsed` -> `Stack trace analyzed` -> `Repository indexed` -> `Git correlated` -> `Dependency path built` -> `Generating hypotheses`).
4. **Screen 04 — Investigate**: Ranked competing hypotheses with confidence scoring and heuristic breakdowns (Stack trace +30, Dependency path +20, Recent change +20, etc.).
5. **Screen 05 — Root Cause (Signature Screen)**: Root cause statement, 91% confidence meter, failure path DAG, and 5 supporting signal tallies.
6. **Screen 06 — Evidence**: Expandable corroborating signal cards with quick drilldown shortcuts.
7. **Screen 07 — Source Evidence**: Syntax-highlighted code viewer displaying `TokenCache.kt` / `alu.v` with line highlighting at the bug line and floating `⚠ Suspicious` callout.
8. **Screen 08 — Git Evidence**: Commit history for commit `a81c2d1` (*"Refactor token caching"*), modified files, and correlation warning.
9. **Screen 09 — Evidence Graph**: DAG causal graph with semantic colors (Red = Failure, Amber = Hypothesis, Green = Evidence, Purple = AI Reasoning).
10. **Screen 10 — Patch Review**: Unified code diff viewer (-/+ line highlighting), risk classification (`LOW`), affected files, and default *Review* action.
11. **Screen 11 — Approval Gate**: Formal confirmation gate before executing code modification.
12. **Screen 12 — Office Kit**: Dual-surface companion view showing laptop repository indexing, test runner readiness, and live sync timeline.
13. **Screen 13 — Verification**: Test harness execution (`./gradlew test` / `iverilog simulation`), Before (✕ FAILED 401) vs After (✓ PASSED 21/21) comparison.
14. **Screen 14 — Proof Card**: Final hero summary card with one-tap export, share, and markdown report generator.

---

## 🛠 Supported Diagnostic Scenarios

- **Software Demo (`INC-2026-001`)**: `klyro-demo-android` HTTP 401 Checkout Failure caused by unvalidated token cache reuse in `TokenCache.kt`.
- **RTL Hardware Verifier (`INC-2026-002`)**: `agentic-rtl-verifier` ALU Subtraction Bug (`alu.v` / `alu_tb.v`) from `Agentic-RTL-Debugger`, where subtraction dropped carry-in.
- **Hardware FIFO Wrap (`INC-2026-003`)**: Synchronous FIFO pointer wrap overflow (`fifo.v`).

Switch between cases instantly using the **Tune** icon in the top navigation bar.

---

## 🚀 Running the App

### Prerequisites
- Flutter SDK (≥ 3.0.0)
- Android Studio / VS Code with Flutter extension
- Android device or emulator (Android 7.0+ / API 24+)

### Run on Android
```bash
cd KLYRO
flutter pub get
flutter run
```

### Run on Chrome / Web
```bash
flutter run -d chrome
```

---

## 🎨 Design System
- **Background**: `#0B0D11` (Deep charcoal / black)
- **Primary**: `#00FF88` (Electric Green)
- **Failure**: `#FF4D4D` (Muted Red)
- **Warning / Hypothesis**: `#F59E0B` (Amber)
- **AI Reasoning**: `#8B5CF6` (Purple)
- **Typography**: Inter (UI) & JetBrains Mono (Code/Logs)
