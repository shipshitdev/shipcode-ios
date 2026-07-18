import Foundation

@MainActor
protocol ShipCodeClient: AnyObject {
  var connectionState: ShipCodeConnectionState { get }

  func fetchSessions() async throws -> [ShipCodeSession]
  func fetchIssues() async throws -> [ShipCodeIssue]
  func fetchAutomations() async throws -> [ShipCodeAutomation]
  func moveIssue(id: ShipCodeIssue.ID, to lane: IssueLane) async throws
  func setAutomationEnabled(id: ShipCodeAutomation.ID, enabled: Bool) async throws
  func runAutomation(id: ShipCodeAutomation.ID) async throws
}

struct AppSnapshot: Equatable, Sendable {
  var sessions: [ShipCodeSession]
  var issues: [ShipCodeIssue]
  var automations: [ShipCodeAutomation]

  static let empty = AppSnapshot(sessions: [], issues: [], automations: [])
  static let demo = AppSnapshot(
    sessions: DemoFixtures.sessions,
    issues: DemoFixtures.issues,
    automations: DemoFixtures.automations
  )
}
