import Foundation

enum IssueLane: String, CaseIterable, Codable, Hashable, Identifiable, Sendable {
  case backlog = "Backlog"
  case agent = "Agent"
  case attention = "Attention"
  case done = "Done"
  case deferred = "Deferred"

  var id: Self { self }

  var symbolName: String {
    switch self {
    case .backlog: "tray.full"
    case .agent: "bolt"
    case .attention: "exclamationmark.bubble"
    case .done: "checkmark.circle.fill"
    case .deferred: "clock.arrow.circlepath"
    }
  }
}
