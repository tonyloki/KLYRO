import '../models/evidence.dart';
import '../models/hypothesis.dart';
import '../models/incident.dart';
import '../models/patch.dart';
import '../models/verification.dart';
import '../models/workflow_state.dart';

class MockIncidents {
  // ─── 01. Signature Demo: Checkout Failure HTTP 401 ─────────────────────────
  static Incident get checkoutFailureIncident => Incident(
        id: 'INC-2026-001',
        title: 'Checkout Failure',
        project: 'klyro-demo-android',
        type: IncidentType.softwareAndroid,
        failureName: 'HTTP 401 Unauthorized',
        failureDetail: 'Authentication failure during payment checkout flow',
        status: IncidentStatus.investigating,
        detectedFile: 'AuthInterceptor.kt',
        detectedLine: 184,
        capturedEvidenceTags: [
          'HTTP 401 Unauthorized',
          'AuthInterceptor.kt:184',
          'PaymentRepository.kt:67',
          'CheckoutScreen.kt:42',
        ],
        analysisSteps: [
          'Failure parsed',
          'Stack trace analyzed',
          'Repository indexed',
          'Git history correlated',
          'Dependency path built',
          'Generating hypotheses...',
        ],
        hypotheses: const [
          Hypothesis(
            id: 'H1',
            title: 'Expired token reused from TokenCache',
            description:
                'Cached auth token returned without expiration check causes API gateway 401 rejection.',
            confidencePercentage: 91,
            isTopRanked: true,
            breakdown: HeuristicBreakdown(
              stackTraceWeight: 30,
              dependencyPathWeight: 20,
              recentChangeWeight: 20,
              logMatchWeight: 15,
              testOverlapWeight: 10,
              modelPriorWeight: 5,
            ),
          ),
          Hypothesis(
            id: 'H2',
            title: 'Invalid API credentials in PaymentRepository',
            description:
                'Payment gateway client secret expired or missing required bearer signature.',
            confidencePercentage: 54,
            isTopRanked: false,
            breakdown: HeuristicBreakdown(
              stackTraceWeight: 15,
              dependencyPathWeight: 15,
              recentChangeWeight: 10,
              logMatchWeight: 8,
              testOverlapWeight: 4,
              modelPriorWeight: 2,
            ),
          ),
          Hypothesis(
            id: 'H3',
            title: 'Backend authentication gateway transient failure',
            description:
                'Remote OAuth2 server returned intermittent HTTP 401 due to clock skew.',
            confidencePercentage: 21,
            isTopRanked: false,
            breakdown: HeuristicBreakdown(
              stackTraceWeight: 5,
              dependencyPathWeight: 5,
              recentChangeWeight: 4,
              logMatchWeight: 4,
              testOverlapWeight: 2,
              modelPriorWeight: 1,
            ),
          ),
        ],
        rootCauseTitle: 'Expired authentication token reused from TokenCache',
        rootCauseDescription:
            'TokenCache.kt was modified 2 hours ago to return cached tokens unconditionally without validating TTL. During checkout, expired tokens are forwarded to the payment gateway, provoking HTTP 401.',
        confidence: 91,
        failurePathNodes: [
          'CheckoutScreen',
          'PaymentRepository',
          'AuthInterceptor',
          'TokenCache',
          'Expired Token',
          'HTTP 401',
        ],
        evidenceSignals: const [
          EvidenceSignal(
            title: 'Called by AuthInterceptor.kt:184',
            subtitle: 'Direct callsite in payment request interceptor',
            details:
                'AuthInterceptor retrieves token via TokenCache.getToken() before executing executePaymentRequest()',
            type: 'code',
          ),
          EvidenceSignal(
            title: 'Used immediately before HTTP 401',
            subtitle: 'Log correlation timestamp match (<12ms delta)',
            details:
                'Log sequence: [14:02:11.204] TokenCache hit -> [14:02:11.216] HTTP POST /checkout 401 Unauthorized',
            type: 'log',
          ),
          EvidenceSignal(
            title: "Token expiration isn't checked",
            subtitle: 'Static analysis ast-rule violation',
            details:
                'TokenCache.kt lines 41-43 checks for non-null without calling isExpired() or checking epoch timestamp',
            type: 'code',
          ),
          EvidenceSignal(
            title: 'Modified in recent commit a81c2d1',
            subtitle: 'Git blame shows commit 2 hours ago by @sarah.dev',
            details:
                'Commit message "Refactor token caching" removed TTL validation clause',
            type: 'git',
          ),
          EvidenceSignal(
            title: 'Related test is failing: PaymentRepositoryTest',
            subtitle: 'Unit test regression detected in test suite',
            details:
                'PaymentRepositoryTest.shouldRefreshExpiredTokenOnCheckout() expected 200 but received 401',
            type: 'test',
          ),
        ],
        sourceSnippet: const SourceSnippet(
          filename: 'TokenCache.kt',
          startLine: 40,
          lines: [
            'fun getToken(): String {',
            '    if (cacheToken != null) {',
            '        return cacheToken',
            '    }',
            '',
            '    return fetchNewToken()',
            '}',
          ],
          suspiciousLineIndex: 2, // line 42
          suspiciousReason:
              'Cached token returned without expiration validation.',
        ),
        gitCommitInfo: const GitCommitInfo(
          commitHash: 'a81c2d1',
          author: 'sarah.dev',
          timeAgo: '2 hours ago',
          message: 'Refactor token caching',
          filesChanged: [
            'TokenCache.kt',
            'AuthInterceptor.kt',
          ],
          diffSummary: '- validate expiration\n+ return cachedToken',
        ),
        graphNodes: const [
          GraphNode(
            id: 'n1',
            label: 'HTTP 401',
            type: GraphNodeType.failure,
            subtitle: 'Payment Gateway',
          ),
          GraphNode(
            id: 'n2',
            label: 'PaymentRepository',
            type: GraphNodeType.evidence,
            subtitle: 'Repository Layer',
          ),
          GraphNode(
            id: 'n3',
            label: 'AuthInterceptor',
            type: GraphNodeType.evidence,
            subtitle: 'Network Interceptor',
          ),
          GraphNode(
            id: 'n4',
            label: 'TokenCache',
            type: GraphNodeType.reasoning,
            subtitle: 'In-Memory Cache',
          ),
          GraphNode(
            id: 'n5',
            label: 'cachedToken',
            type: GraphNodeType.evidence,
            subtitle: 'State Variable',
          ),
          GraphNode(
            id: 'n6',
            label: 'expiry check [✕]',
            type: GraphNodeType.failure,
            subtitle: 'Missing Validation',
          ),
          GraphNode(
            id: 'n7',
            label: 'EXPIRED TOKEN',
            type: GraphNodeType.hypothesis,
            subtitle: 'Root Mechanism',
          ),
        ],
        graphEdges: const [
          GraphEdge(fromId: 'n1', toId: 'n2', label: 'throws'),
          GraphEdge(fromId: 'n2', toId: 'n3', label: 'invokes'),
          GraphEdge(fromId: 'n3', toId: 'n4', label: 'queries token'),
          GraphEdge(fromId: 'n4', toId: 'n5', label: 'reads'),
          GraphEdge(fromId: 'n4', toId: 'n6', label: 'bypasses', isBlocked: true),
          GraphEdge(fromId: 'n5', toId: 'n7', label: 'forwards stale'),
          GraphEdge(fromId: 'n7', toId: 'n1', label: 'causes 401'),
        ],
        patch: const PatchProposal(
          filename: 'TokenCache.kt',
          commitMessage: 'fix(auth): check token expiration before returning from cache',
          whyExplanation:
              'Prevents expired tokens from reaching checkout by verifying !cacheToken.isExpired() before returning, otherwise triggering automatic token refresh.',
          riskLevel: RiskLevel.low,
          filesAffected: 1,
          additions: 3,
          deletions: 1,
          diffLines: [
            PatchLine(text: ' fun getToken(): String {', isAdded: false, isRemoved: false),
            PatchLine(text: '-    return cacheToken', isAdded: false, isRemoved: true),
            PatchLine(text: '+    if (!cacheToken.isExpired()) {', isAdded: true, isRemoved: false),
            PatchLine(text: '+        return cacheToken', isAdded: true, isRemoved: false),
            PatchLine(text: '+    }', isAdded: true, isRemoved: false),
            PatchLine(text: '     return fetchNewToken()', isAdded: false, isRemoved: false),
            PatchLine(text: ' }', isAdded: false, isRemoved: false),
          ],
        ),
        verification: const VerificationResult(
          testCommand: './gradlew test --tests PaymentRepositoryTest',
          testTarget: 'PaymentRepositoryTest',
          beforeStatus: 'FAILED',
          beforeExpected: 'Expected HTTP 200 OK with valid checkout response',
          beforeReceived: 'Received HTTP 401 Unauthorized (Expired Bearer Token)',
          beforeLog: 'PaymentRepositoryTest > testCheckoutFlow() FAILED\n    org.opentest4j.AssertionFailedError: expected: <200> but was: <401>\n    at AuthInterceptor.kt:184\n    at PaymentRepositoryTest.kt:45',
          afterStatus: 'PASSED',
          totalTests: 21,
          passedTests: 21,
          afterLog: 'PaymentRepositoryTest > testCheckoutFlow() PASSED\nPaymentRepositoryTest > testTokenRefreshOnExpiry() PASSED\nPaymentRepositoryTest > testConcurrentPaymentRequests() PASSED\n\nBUILD SUCCESSFUL in 1.4s\n21 tests completed, 0 failed, 0 skipped',
        ),
      );

  // ─── 02. RTL Hardware Debugger: ALU Arithmetic Underflow (alu_bug) ─────────
  static Incident get aluBugIncident => Incident(
        id: 'INC-2026-002',
        title: 'ALU Subtraction Carry Inversion',
        project: 'agentic-rtl-verifier',
        type: IncidentType.hardwareVerilogRTL,
        failureName: 'Assertion Error @ 145ns (alu_tb)',
        failureDetail: 'ALU SUB operation 0x04 - 0x05 yielded 0x01 instead of 0xFF (carry mismatch)',
        status: IncidentStatus.investigating,
        detectedFile: 'alu.v',
        detectedLine: 28,
        capturedEvidenceTags: [
          'iverilog assertion fail',
          'alu.v:28 (opcode 3\'b001)',
          'alu_tb.v:64 (@145ns)',
          'temporal_wf_rtl_alu_09',
        ],
        analysisSteps: [
          'Verilog AST parsed',
          'Icarus simulation log analyzed',
          'RTL module dependency mapped',
          'Waveform VCD signal transitions extracted',
          'Synthesis constraint checked',
          'Generating RTL hypotheses...',
        ],
        hypotheses: const [
          Hypothesis(
            id: 'H1',
            title: 'Incorrect two\'s complement inversion in SUB opcode',
            description:
                'ALU SUB branch uses `a + ~b` instead of `a + ~b + 1` (or `a - b`), dropping carry-in bit.',
            confidencePercentage: 96,
            isTopRanked: true,
            breakdown: HeuristicBreakdown(
              stackTraceWeight: 35,
              dependencyPathWeight: 25,
              recentChangeWeight: 15,
              logMatchWeight: 12,
              testOverlapWeight: 6,
              modelPriorWeight: 3,
            ),
          ),
          Hypothesis(
            id: 'H2',
            title: 'Testbench stimulus clock timing jitter',
            description:
                'Setup/hold violation in testbench driving inputs during active posedge clock edge.',
            confidencePercentage: 38,
            isTopRanked: false,
            breakdown: HeuristicBreakdown(
              stackTraceWeight: 10,
              dependencyPathWeight: 10,
              recentChangeWeight: 8,
              logMatchWeight: 5,
              testOverlapWeight: 3,
              modelPriorWeight: 2,
            ),
          ),
        ],
        rootCauseTitle: 'Missing carry-in (+1) in subtraction opcode (alu.v:28)',
        rootCauseDescription:
            'In case 3\'b001 (SUB), the assignment `result = a + ~b;` produces one\'s complement instead of two\'s complement, causing off-by-one arithmetic error on all subtraction cycles.',
        confidence: 96,
        failurePathNodes: [
          'alu_tb.v (Test Vector 4)',
          'clk edge @ 145ns',
          'alu.v:case(opcode)',
          'case 3\'b001: a + ~b',
          'Missing +1 Carry',
          'result = 8\'h01 (exp 8\'hFF)',
        ],
        evidenceSignals: const [
          EvidenceSignal(
            title: 'alu.v:28 opcode handler',
            subtitle: 'Arithmetic logic block assignment',
            details: 'Line 28: 3\'b001: result = a + (~b); drops 1\'b1 carry in',
            type: 'code',
          ),
          EvidenceSignal(
            title: 'Icarus Verilog failure log @ 145ns',
            subtitle: 'VVP simulation output mismatch',
            details: 'ERROR: ALU SUB test failed! a=04, b=05, expected=ff, got=01',
            type: 'log',
          ),
          EvidenceSignal(
            title: 'Temporal Durable Workflow signal gate',
            subtitle: 'Workflow ID: wf_rtl_alu_09 pending human signoff',
            details: 'Workflow execution suspended waiting for mobile approval token',
            type: 'test',
          ),
        ],
        sourceSnippet: const SourceSnippet(
          filename: 'alu.v',
          startLine: 24,
          lines: [
            'always @(*) begin',
            '    case (opcode)',
            '        3\'b000: result = a + b;',
            '        3\'b001: result = a + (~b); // BUG: missing + 1',
            '        3\'b010: result = a & b;',
            '        3\'b011: result = a | b;',
            '        default: result = 8\'h00;',
            '    endcase',
            'end',
          ],
          suspiciousLineIndex: 3, // line 28
          suspiciousReason: 'Missing +1 for two\'s complement subtraction.',
        ),
        gitCommitInfo: const GitCommitInfo(
          commitHash: 'c4e9102',
          author: 'alex.hw',
          timeAgo: '5 hours ago',
          message: 'Optimize ALU arithmetic datapath logic',
          filesChanged: ['alu.v'],
          diffSummary: '- result = a - b;\n+ result = a + (~b);',
        ),
        graphNodes: const [
          GraphNode(id: 'r1', label: 'VVP Simulation Fail', type: GraphNodeType.failure),
          GraphNode(id: 'r2', label: 'alu_tb (Vector 4)', type: GraphNodeType.evidence),
          GraphNode(id: 'r3', label: 'alu.v (always @*)', type: GraphNodeType.evidence),
          GraphNode(id: 'r4', label: 'Opcode 3\'b001', type: GraphNodeType.reasoning),
          GraphNode(id: 'r5', label: 'One\'s Complement Only', type: GraphNodeType.hypothesis),
          GraphNode(id: 'r6', label: 'Missing Carry +1', type: GraphNodeType.failure),
        ],
        graphEdges: const [
          GraphEdge(fromId: 'r1', toId: 'r2', label: 'triggered by'),
          GraphEdge(fromId: 'r2', toId: 'r3', label: 'inputs (a=4,b=5)'),
          GraphEdge(fromId: 'r3', toId: 'r4', label: 'executes'),
          GraphEdge(fromId: 'r4', toId: 'r5', label: 'computes a + ~b'),
          GraphEdge(fromId: 'r5', toId: 'r6', label: 'produces bug'),
        ],
        patch: const PatchProposal(
          filename: 'alu.v',
          commitMessage: 'fix(rtl): use correct two\'s complement subtraction in ALU',
          whyExplanation:
              'Fixes ALU SUB computation to use `a - b` (synthesizing proper full subtractor with borrow-in).',
          riskLevel: RiskLevel.low,
          filesAffected: 1,
          additions: 1,
          deletions: 1,
          diffLines: [
            PatchLine(text: '     case (opcode)', isAdded: false, isRemoved: false),
            PatchLine(text: '-        3\'b001: result = a + (~b);', isAdded: false, isRemoved: true),
            PatchLine(text: '+        3\'b001: result = a - b;', isAdded: true, isRemoved: false),
            PatchLine(text: '         3\'b010: result = a & b;', isAdded: false, isRemoved: false),
          ],
        ),
        verification: const VerificationResult(
          testCommand: 'iverilog -o sim.out alu.v alu_tb.v && vvp sim.out',
          testTarget: 'alu_tb',
          beforeStatus: 'FAILED',
          beforeExpected: 'result == 8\'hFF',
          beforeReceived: 'result == 8\'h01',
          beforeLog: 'VCD info: dumpfile dump.vcd opened for output.\n[145ns] ERROR: ALU SUB failed: a=04 b=05 expected=ff got=01\nSimulation finished with 1 error.',
          afterStatus: 'PASSED',
          totalTests: 16,
          passedTests: 16,
          afterLog: 'VCD info: dumpfile dump.vcd opened for output.\n[50ns] PASS: ADD test\n[145ns] PASS: SUB test (a=04, b=05 -> result=ff)\n[250ns] PASS: AND/OR/XOR vectors\n\nALL 16 RTL VECTORS PASSED. Simulation completed successfully.',
        ),
      );

  // ─── 03. Synchronous FIFO Pointer Wrap Bug (fifo_bug) ──────────────────────
  static Incident get fifoBugIncident => Incident(
        id: 'INC-2026-003',
        title: 'FIFO Pointer Wrap & Overflow',
        project: 'agentic-rtl-verifier',
        type: IncidentType.hardwareVerilogRTL,
        failureName: 'Data Corruption on Wrap @ 320ns',
        failureDetail: 'FIFO full flag failed to assert on 8th write; overwritten slot 0',
        status: IncidentStatus.verified,
        detectedFile: 'fifo.v',
        detectedLine: 45,
        capturedEvidenceTags: [
          'fifo.v:45',
          'fifo_tb.v:92',
          'overflow flag 0->0',
        ],
        analysisSteps: [
          'Verilog AST parsed',
          'Log parsed',
          'State analyzed',
          'Hypothesis proven',
        ],
        hypotheses: const [
          Hypothesis(
            id: 'H1',
            title: 'Missing MSB extra bit for FIFO empty/full distinction',
            description: 'Pointers wrap at 3-bits without 4th MSB comparison flag.',
            confidencePercentage: 94,
            isTopRanked: true,
          ),
        ],
        rootCauseTitle: 'FIFO pointer wrap without MSB depth comparison',
        rootCauseDescription: '3-bit read and write pointers cannot differentiate between full and empty state without an extra MSB or counter.',
        confidence: 94,
        failurePathNodes: [
          'fifo_tb.v',
          '8 writes issued',
          'fifo.v:wr_ptr wraps',
          'full flag stays 0',
          '9th write overwrites slot 0',
        ],
        evidenceSignals: const [
          EvidenceSignal(
            title: 'fifo.v:45 pointer logic',
            subtitle: 'wr_ptr <= wr_ptr + 1',
            details: 'Depth is 8, wr_ptr is 3 bits: wraps silently from 7 to 0',
            type: 'code',
          ),
        ],
        sourceSnippet: const SourceSnippet(
          filename: 'fifo.v',
          startLine: 40,
          lines: [
            'always @(posedge clk or posedge rst) begin',
            '    if (rst) wr_ptr <= 0;',
            '    else if (wr_en && !full) begin',
            '        mem[wr_ptr] <= data_in;',
            '        wr_ptr <= wr_ptr + 1;',
            '    end',
            'end',
          ],
          suspiciousLineIndex: 4,
          suspiciousReason: 'Unchecked pointer rollover.',
        ),
        gitCommitInfo: const GitCommitInfo(
          commitHash: 'e921b77',
          author: 'david.eng',
          timeAgo: '1 day ago',
          message: 'Initial FIFO implementation',
          filesChanged: ['fifo.v'],
          diffSummary: '+ fifo memory array implementation',
        ),
        graphNodes: const [
          GraphNode(id: 'f1', label: 'FIFO Data Drop', type: GraphNodeType.failure),
          GraphNode(id: 'f2', label: 'fifo.v wr_ptr', type: GraphNodeType.evidence),
          GraphNode(id: 'f3', label: 'full == 0 flag', type: GraphNodeType.hypothesis),
        ],
        graphEdges: const [
          GraphEdge(fromId: 'f1', toId: 'f2', label: 'caused by'),
          GraphEdge(fromId: 'f2', toId: 'f3', label: 'bypasses full check'),
        ],
        patch: const PatchProposal(
          filename: 'fifo.v',
          commitMessage: 'fix(rtl): use 4-bit pointers to distinguish FIFO full and empty states',
          whyExplanation: 'Adds 4th MSB bit to read/write pointers to detect full condition accurately.',
          diffLines: [
            PatchLine(text: '- reg [2:0] wr_ptr, rd_ptr;', isRemoved: true),
            PatchLine(text: '+ reg [3:0] wr_ptr, rd_ptr;', isAdded: true),
            PatchLine(text: '+ assign full = (wr_ptr[3] != rd_ptr[3]) && (wr_ptr[2:0] == rd_ptr[2:0]);', isAdded: true),
          ],
        ),
        verification: const VerificationResult(
          testCommand: 'iverilog -o fifo_sim.out fifo.v fifo_tb.v && vvp fifo_sim.out',
          testTarget: 'fifo_tb',
          beforeStatus: 'FAILED',
          beforeExpected: 'full == 1 on 8th push',
          beforeReceived: 'full == 0 on 8th push',
          beforeLog: 'ERROR: FIFO failed full-assertion at t=320ns',
          afterStatus: 'PASSED',
          totalTests: 12,
          passedTests: 12,
          afterLog: 'ALL 12 FIFO STRESS CYCLES PASSED.',
        ),
      );

  static List<Incident> get allIncidents => [
        checkoutFailureIncident,
        aluBugIncident,
        fifoBugIncident,
      ];
}
