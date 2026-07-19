import Foundation

enum DemoFixtures {
  static let sessions: [ShipCodeSession] = [
    ShipCodeSession(
      id: UUID(uuidString: "A0000000-0000-0000-0000-000000000001")!,
      projectName: "shipcode",
      title: "Native iOS control plane",
      phase: .executing,
      model: "gpt-5.6-sol",
      githubIssueNumber: 412,
      githubPullRequestNumber: nil,
      totalCostUSD: 1.42,
      lastError: nil,
      createdAt: date("2026-07-18T08:30:00Z"),
      updatedAt: date("2026-07-18T10:42:00Z")
    ),
    ShipCodeSession(
      id: UUID(uuidString: "A0000000-0000-0000-0000-000000000002")!,
      projectName: "genfeed.ai",
      title: "Repair publishing queue retries",
      phase: .approval,
      model: "fable-5",
      githubIssueNumber: 982,
      githubPullRequestNumber: nil,
      totalCostUSD: 0.88,
      lastError: nil,
      createdAt: date("2026-07-18T07:10:00Z"),
      updatedAt: date("2026-07-18T10:12:00Z")
    ),
    ShipCodeSession(
      id: UUID(uuidString: "A0000000-0000-0000-0000-000000000003")!,
      projectName: "vitae",
      title: "Add candidate export audit trail",
      phase: .completed,
      model: "gpt-5.6-sol",
      githubIssueNumber: 284,
      githubPullRequestNumber: 291,
      totalCostUSD: 2.17,
      lastError: nil,
      createdAt: date("2026-07-17T12:00:00Z"),
      updatedAt: date("2026-07-17T14:48:00Z")
    ),
    ShipCodeSession(
      id: UUID(uuidString: "A0000000-0000-0000-0000-000000000004")!,
      projectName: "shipcode",
      title: "Harden project status reconciliation",
      phase: .failed,
      model: "gpt-5.6-sol",
      githubIssueNumber: 410,
      githubPullRequestNumber: nil,
      totalCostUSD: 0.63,
      lastError: "GitHub Projects status changed while the local cache was stale.",
      createdAt: date("2026-07-17T09:22:00Z"),
      updatedAt: date("2026-07-17T09:51:00Z")
    ),
  ]

  static let issues: [ShipCodeIssue] = [
    ShipCodeIssue(
      id: "shipshitdev/shipcode#412",
      repository: "shipshitdev/shipcode",
      number: 412,
      title: "Native iOS control plane",
      lane: .agent,
      priority: "P0",
      assignee: "VincentShipsIt",
      labels: ["shipcode:agent:codex", "mobile"],
      linkedPullRequestNumber: nil,
      updatedAt: date("2026-07-18T10:42:00Z")
    ),
    ShipCodeIssue(
      id: "shipshitdev/shipcode#413",
      repository: "shipshitdev/shipcode",
      number: 413,
      title: "Make Projects v2 refresh GitHub-authoritative",
      lane: .backlog,
      priority: "P0",
      assignee: nil,
      labels: ["sync", "github"],
      linkedPullRequestNumber: nil,
      updatedAt: date("2026-07-18T09:35:00Z")
    ),
    ShipCodeIssue(
      id: "shipshitdev/shipcode#409",
      repository: "shipshitdev/shipcode",
      number: 409,
      title: "Resolve updater bootstrap failure",
      lane: .attention,
      priority: "P1",
      assignee: "VincentShipsIt",
      labels: ["bug"],
      linkedPullRequestNumber: 411,
      updatedAt: date("2026-07-18T08:54:00Z")
    ),
    ShipCodeIssue(
      id: "shipshitdev/shipcode#408",
      repository: "shipshitdev/shipcode",
      number: 408,
      title: "Prepare the 0.2.1 release",
      lane: .done,
      priority: "P1",
      assignee: "VincentShipsIt",
      labels: ["release"],
      linkedPullRequestNumber: 408,
      updatedAt: date("2026-07-17T18:20:00Z")
    ),
    ShipCodeIssue(
      id: "shipshitdev/shipcode#401",
      repository: "shipshitdev/shipcode",
      number: 401,
      title: "Explore remote terminal streaming",
      lane: .deferred,
      priority: "P3",
      assignee: nil,
      labels: ["later"],
      linkedPullRequestNumber: nil,
      updatedAt: date("2026-07-16T14:00:00Z")
    ),
  ]

  static let automations: [ShipCodeAutomation] = [
    ShipCodeAutomation(
      id: UUID(uuidString: "B0000000-0000-0000-0000-000000000001")!,
      name: "Daily dependency audit",
      projectNames: ["shipcode"],
      schedule: "Every day at 07:00 UTC",
      enabled: true,
      lastStatus: .completed,
      lastStartedAt: date("2026-07-18T07:00:00Z"),
      nextRunAt: date("2026-07-19T07:00:00Z"),
      runCount: 21
    ),
    ShipCodeAutomation(
      id: UUID(uuidString: "B0000000-0000-0000-0000-000000000002")!,
      name: "Weekly release notes",
      projectNames: ["shipcode", "genfeed.ai"],
      schedule: "Mondays at 08:30 UTC",
      enabled: true,
      lastStatus: .failed,
      lastStartedAt: date("2026-07-13T08:30:00Z"),
      nextRunAt: date("2026-07-20T08:30:00Z"),
      runCount: 8
    ),
    ShipCodeAutomation(
      id: UUID(uuidString: "B0000000-0000-0000-0000-000000000003")!,
      name: "Stale issue sweep",
      projectNames: ["vitae"],
      schedule: "Fridays at 16:00 UTC",
      enabled: false,
      lastStatus: nil,
      lastStartedAt: nil,
      nextRunAt: nil,
      runCount: 0
    ),
  ]

  private static func date(_ value: String) -> Date {
    ISO8601DateFormatter().date(from: value)!
  }
}
