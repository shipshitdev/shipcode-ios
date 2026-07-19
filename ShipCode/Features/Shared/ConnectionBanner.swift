import SwiftUI

struct ConnectionBanner: View {
  let state: ShipCodeConnectionState

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: symbolName)
        .font(.headline)
        .foregroundStyle(tint)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: 3) {
        Text(title)
          .font(.subheadline.weight(.semibold))
        Text(detail)
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Spacer(minLength: 0)
    }
    .accessibilityElement(children: .combine)
  }

  private var title: String {
    switch state {
    case .demo: "Demo mode"
    case .githubConnected(let account): "GitHub · \(account)"
    case .desktopConnected(let name): "Desktop · \(name)"
    case .offline: "Offline"
    }
  }

  private var detail: String {
    switch state {
    case .demo:
      "Explore deterministic ShipCode data without connecting an account."
    case .githubConnected:
      "Issues sync directly with GitHub."
    case .desktopConnected:
      "Sessions and automations are available."
    case .offline(let lastUpdatedAt):
      if let lastUpdatedAt {
        "Showing data last updated \(lastUpdatedAt.formatted(.relative(presentation: .named)))."
      } else {
        "Connect to GitHub or a paired desktop to refresh."
      }
    }
  }

  private var symbolName: String {
    switch state {
    case .demo: "sparkles"
    case .githubConnected: "checkmark.icloud"
    case .desktopConnected: "desktopcomputer"
    case .offline: "wifi.slash"
    }
  }

  private var tint: Color {
    switch state {
    case .demo: .purple
    case .githubConnected, .desktopConnected: .green
    case .offline: .orange
    }
  }
}

#Preview {
  ConnectionBanner(state: .demo)
    .padding()
}
