import SwiftUI

struct StatusBadge: View {
  enum Tone {
    case neutral
    case agent
    case attention
    case success
  }

  let title: String
  let systemImage: String
  let tone: Tone

  var body: some View {
    Label(title, systemImage: systemImage)
      .font(.caption.weight(.semibold))
      .foregroundStyle(color)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(color.opacity(0.12), in: Capsule())
      .accessibilityElement(children: .combine)
  }

  private var color: Color {
    switch tone {
    case .neutral: .secondary
    case .agent: .blue
    case .attention: .orange
    case .success: .green
    }
  }
}

extension StatusBadge.Tone {
  init(phase: PipelinePhase) {
    switch phase {
    case .completed:
      self = .success
    case .failed, .approval, .clarifying, .paused:
      self = .attention
    case .planning, .reviewing, .revising, .executing, .testing, .verifying, .shipping:
      self = .agent
    case .idle:
      self = .neutral
    }
  }

  init(lane: IssueLane) {
    switch lane {
    case .agent:
      self = .agent
    case .attention:
      self = .attention
    case .done:
      self = .success
    case .backlog, .deferred:
      self = .neutral
    }
  }
}
