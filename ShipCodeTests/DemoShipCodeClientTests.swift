import Testing

@testable import ShipCode

@MainActor
@Suite("Demo ShipCode client")
struct DemoShipCodeClientTests {
  @Test("fixtures cover every issue lane")
  func fixturesCoverEveryIssueLane() {
    let fixtureLanes = Set(DemoFixtures.issues.map(\.lane))
    #expect(fixtureLanes == Set(IssueLane.allCases))
  }

  @Test("moving an issue updates its lane")
  func moveIssue() async throws {
    let client = DemoShipCodeClient()
    let issue = try #require(try await client.fetchIssues().first)

    try await client.moveIssue(id: issue.id, to: .done)

    let updatedIssue = try #require(
      try await client.fetchIssues().first { $0.id == issue.id }
    )
    #expect(updatedIssue.lane == .done)
  }

  @Test("automation mutations preserve identity and update state")
  func automationMutations() async throws {
    let client = DemoShipCodeClient()
    let automation = try #require(try await client.fetchAutomations().first)

    try await client.setAutomationEnabled(id: automation.id, enabled: false)
    try await client.runAutomation(id: automation.id)

    let updated = try #require(
      try await client.fetchAutomations().first { $0.id == automation.id }
    )
    #expect(updated.enabled == false)
    #expect(updated.lastStatus == .running)
    #expect(updated.runCount == automation.runCount + 1)
  }
}

@Suite("ShipCode state vocabulary")
struct ShipCodeStateVocabularyTests {
  @Test("issue lanes match the desktop macro columns")
  func issueLanes() {
    #expect(
      IssueLane.allCases.map(\.rawValue) == [
        "Backlog",
        "Agent",
        "Attention",
        "Done",
        "Deferred",
      ])
  }

  @Test("active phases match the desktop pipeline")
  func activePhases() {
    #expect(PipelinePhase.executing.isActive)
    #expect(PipelinePhase.approval.isActive)
    #expect(PipelinePhase.paused.isActive)
    #expect(!PipelinePhase.completed.isActive)
    #expect(!PipelinePhase.failed.isActive)
  }
}
