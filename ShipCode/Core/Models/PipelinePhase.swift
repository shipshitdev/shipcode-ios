import Foundation

enum PipelinePhase: String, CaseIterable, Codable, Hashable, Identifiable, Sendable {
  case idle
  case planning
  case clarifying
  case reviewing
  case revising
  case approval
  case executing
  case testing
  case verifying
  case shipping
  case paused
  case completed
  case failed

  var id: Self { self }

  var displayName: String {
    switch self {
    case .idle: "Idle"
    case .planning: "Planning"
    case .clarifying: "Clarifying"
    case .reviewing: "Reviewing"
    case .revising: "Revising"
    case .approval: "Approval"
    case .executing: "Executing"
    case .testing: "Testing"
    case .verifying: "Verifying"
    case .shipping: "Shipping"
    case .paused: "Paused"
    case .completed: "Completed"
    case .failed: "Failed"
    }
  }

  var symbolName: String {
    switch self {
    case .idle: "circle"
    case .planning: "list.bullet.clipboard"
    case .clarifying: "questionmark.bubble"
    case .reviewing: "checklist"
    case .revising: "arrow.triangle.2.circlepath"
    case .approval: "hand.raised"
    case .executing: "bolt"
    case .testing: "testtube.2"
    case .verifying: "checkmark.seal"
    case .shipping: "shippingbox"
    case .paused: "pause.circle"
    case .completed: "checkmark.circle.fill"
    case .failed: "exclamationmark.triangle.fill"
    }
  }

  var isActive: Bool {
    switch self {
    case .planning, .clarifying, .reviewing, .revising, .approval,
      .executing, .testing, .verifying, .shipping, .paused:
      true
    case .idle, .completed, .failed:
      false
    }
  }
}
