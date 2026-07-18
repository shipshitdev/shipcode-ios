import SwiftUI

struct SessionsView: View {
  @Environment(AppModel.self) private var model

  var body: some View {
    List {
      Section {
        ConnectionBanner(state: model.connectionState)
      }

      if !model.activeSessions.isEmpty {
        Section("Active") {
          ForEach(model.activeSessions) { session in
            NavigationLink(value: session) {
              SessionRow(session: session)
            }
          }
        }
      }

      if !model.recentSessions.isEmpty {
        Section("Recent") {
          ForEach(model.recentSessions) { session in
            NavigationLink(value: session) {
              SessionRow(session: session)
            }
          }
        }
      }
    }
    .navigationTitle("Sessions")
    .navigationDestination(for: ShipCodeSession.self) { session in
      SessionDetailView(session: session)
    }
    .refreshable {
      await model.refreshSessions()
    }
    .overlay {
      if model.isRefreshingSessions, model.sessions.isEmpty {
        ProgressView("Loading sessions")
      } else if model.sessions.isEmpty {
        ContentUnavailableView(
          "No Sessions",
          systemImage: "bolt.horizontal.circle",
          description: Text("Active and recent ShipCode runs will appear here.")
        )
      }
    }
  }
}

private struct SessionRow: View {
  let session: ShipCodeSession

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(alignment: .firstTextBaseline) {
        Text(session.title)
          .font(.headline)
          .lineLimit(2)
        Spacer(minLength: 8)
        StatusBadge(
          title: session.phase.displayName,
          systemImage: session.phase.symbolName,
          tone: .init(phase: session.phase)
        )
      }

      HStack(spacing: 6) {
        Text(session.projectName)
        Text("·")
        Text(session.model)
        Spacer()
        Text(session.updatedAt, style: .relative)
      }
      .font(.caption)
      .foregroundStyle(.secondary)
    }
    .padding(.vertical, 3)
    .accessibilityElement(children: .combine)
  }
}

#Preview {
  NavigationStack {
    SessionsView()
  }
  .environment(AppModel.preview)
}
