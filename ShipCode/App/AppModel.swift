import Foundation
import Observation

@MainActor
@Observable
final class AppModel {
  private(set) var sessions: [ShipCodeSession] {
    didSet { rebuildSessionSections() }
  }

  private(set) var activeSessions: [ShipCodeSession] = []
  private(set) var recentSessions: [ShipCodeSession] = []

  private(set) var issues: [ShipCodeIssue] {
    didSet { rebuildIssueSections() }
  }

  private(set) var issuesByLane: [IssueLane: [ShipCodeIssue]] = [:]
  private(set) var automations: [ShipCodeAutomation]
  private(set) var connectionState: ShipCodeConnectionState

  private(set) var isRefreshingSessions = false
  private(set) var isRefreshingIssues = false
  private(set) var isRefreshingAutomations = false
  private(set) var mutatingIssueIDs: Set<ShipCodeIssue.ID> = []
  private(set) var mutatingAutomationIDs: Set<ShipCodeAutomation.ID> = []

  var errorMessage: String?
  var isShowingError = false

  @ObservationIgnored
  private let client: any ShipCodeClient

  init(client: any ShipCodeClient, initialSnapshot: AppSnapshot = .empty) {
    self.client = client
    sessions = initialSnapshot.sessions
    issues = initialSnapshot.issues
    automations = initialSnapshot.automations
    connectionState = client.connectionState
    rebuildSessionSections()
    rebuildIssueSections()
  }

  func refreshAll() async {
    await refreshSessions()
    await refreshIssues()
    await refreshAutomations()
  }

  func refreshSessions() async {
    isRefreshingSessions = true
    defer { isRefreshingSessions = false }

    do {
      sessions = try await client.fetchSessions()
      connectionState = client.connectionState
    } catch {
      present(error)
    }
  }

  func refreshIssues() async {
    isRefreshingIssues = true
    defer { isRefreshingIssues = false }

    do {
      issues = try await client.fetchIssues()
      connectionState = client.connectionState
    } catch {
      present(error)
    }
  }

  func refreshAutomations() async {
    isRefreshingAutomations = true
    defer { isRefreshingAutomations = false }

    do {
      automations = try await client.fetchAutomations()
      connectionState = client.connectionState
    } catch {
      present(error)
    }
  }

  func moveIssue(id: ShipCodeIssue.ID, to lane: IssueLane) async {
    guard let index = issues.firstIndex(where: { $0.id == id }) else { return }

    let original = issues[index]
    mutatingIssueIDs.insert(id)
    issues[index].lane = lane
    defer { mutatingIssueIDs.remove(id) }

    do {
      try await client.moveIssue(id: id, to: lane)
      issues = try await client.fetchIssues()
    } catch {
      if let rollbackIndex = issues.firstIndex(where: { $0.id == id }) {
        issues[rollbackIndex] = original
      }
      present(error)
    }
  }

  func setAutomationEnabled(id: ShipCodeAutomation.ID, enabled: Bool) async {
    guard let index = automations.firstIndex(where: { $0.id == id }) else { return }

    let original = automations[index]
    mutatingAutomationIDs.insert(id)
    automations[index].enabled = enabled
    defer { mutatingAutomationIDs.remove(id) }

    do {
      try await client.setAutomationEnabled(id: id, enabled: enabled)
      automations = try await client.fetchAutomations()
    } catch {
      if let rollbackIndex = automations.firstIndex(where: { $0.id == id }) {
        automations[rollbackIndex] = original
      }
      present(error)
    }
  }

  func runAutomation(id: ShipCodeAutomation.ID) async {
    mutatingAutomationIDs.insert(id)
    defer { mutatingAutomationIDs.remove(id) }

    do {
      try await client.runAutomation(id: id)
      automations = try await client.fetchAutomations()
    } catch {
      present(error)
    }
  }

  func issue(id: ShipCodeIssue.ID) -> ShipCodeIssue? {
    issues.first { $0.id == id }
  }

  func automation(id: ShipCodeAutomation.ID) -> ShipCodeAutomation? {
    automations.first { $0.id == id }
  }

  func dismissError() {
    errorMessage = nil
    isShowingError = false
  }

  private func rebuildSessionSections() {
    activeSessions = sessions.filter(\.phase.isActive)
    recentSessions = sessions.filter { !$0.phase.isActive }
  }

  private func rebuildIssueSections() {
    issuesByLane = Dictionary(grouping: issues, by: \.lane)
  }

  private func present(_ error: Error) {
    errorMessage = error.localizedDescription
    isShowingError = true
  }
}

extension AppModel {
  static var preview: AppModel {
    AppModel(client: DemoShipCodeClient(), initialSnapshot: .demo)
  }
}
