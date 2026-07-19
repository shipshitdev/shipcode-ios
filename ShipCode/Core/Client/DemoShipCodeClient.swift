import Foundation

@MainActor
final class DemoShipCodeClient: ShipCodeClient {
  private var snapshot: AppSnapshot

  let connectionState = ShipCodeConnectionState.demo

  init(snapshot: AppSnapshot = .demo) {
    self.snapshot = snapshot
  }

  func fetchSessions() async throws -> [ShipCodeSession] {
    snapshot.sessions
  }

  func fetchIssues() async throws -> [ShipCodeIssue] {
    snapshot.issues
  }

  func fetchAutomations() async throws -> [ShipCodeAutomation] {
    snapshot.automations
  }

  func moveIssue(id: ShipCodeIssue.ID, to lane: IssueLane) async throws {
    guard let index = snapshot.issues.firstIndex(where: { $0.id == id }) else {
      throw DemoClientError.issueNotFound
    }

    snapshot.issues[index].lane = lane
    snapshot.issues[index].updatedAt = .now
  }

  func setAutomationEnabled(id: ShipCodeAutomation.ID, enabled: Bool) async throws {
    guard let index = snapshot.automations.firstIndex(where: { $0.id == id }) else {
      throw DemoClientError.automationNotFound
    }

    snapshot.automations[index].enabled = enabled
  }

  func runAutomation(id: ShipCodeAutomation.ID) async throws {
    guard let index = snapshot.automations.firstIndex(where: { $0.id == id }) else {
      throw DemoClientError.automationNotFound
    }

    snapshot.automations[index].lastStatus = .running
    snapshot.automations[index].lastStartedAt = .now
    snapshot.automations[index].runCount += 1
  }
}

private enum DemoClientError: LocalizedError {
  case issueNotFound
  case automationNotFound

  var errorDescription: String? {
    switch self {
    case .issueNotFound:
      "The demo issue no longer exists."
    case .automationNotFound:
      "The demo automation no longer exists."
    }
  }
}
