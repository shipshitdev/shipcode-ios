import Foundation

struct ShipCodeSession: Identifiable, Codable, Equatable, Hashable, Sendable {
  let id: UUID
  let projectName: String
  let title: String
  var phase: PipelinePhase
  let model: String
  let githubIssueNumber: Int?
  let githubPullRequestNumber: Int?
  let totalCostUSD: Decimal
  let lastError: String?
  let createdAt: Date
  var updatedAt: Date
}

struct ShipCodeIssue: Identifiable, Codable, Equatable, Hashable, Sendable {
  let id: String
  let repository: String
  let number: Int
  let title: String
  var lane: IssueLane
  let priority: String?
  let assignee: String?
  let labels: [String]
  let linkedPullRequestNumber: Int?
  var updatedAt: Date
}

enum AutomationRunStatus: String, Codable, Equatable, Hashable, Sendable {
  case running
  case completed
  case failed

  var displayName: String {
    rawValue.capitalized
  }
}

struct ShipCodeAutomation: Identifiable, Codable, Equatable, Hashable, Sendable {
  let id: UUID
  let name: String
  let projectNames: [String]
  let schedule: String
  var enabled: Bool
  var lastStatus: AutomationRunStatus?
  var lastStartedAt: Date?
  let nextRunAt: Date?
  var runCount: Int
}

enum ShipCodeConnectionState: Equatable, Sendable {
  case demo
  case githubConnected(account: String)
  case desktopConnected(name: String)
  case offline(lastUpdatedAt: Date?)
}
