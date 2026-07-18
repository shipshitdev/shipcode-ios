import SwiftUI

struct AutomationsView: View {
  @Environment(AppModel.self) private var model

  var body: some View {
    List {
      Section {
        ConnectionBanner(state: model.connectionState)
      }

      Section("Schedules") {
        ForEach(model.automations) { automation in
          NavigationLink(value: automation.id) {
            AutomationRow(automation: automation)
          }
        }
      }
    }
    .navigationTitle("Automations")
    .navigationDestination(for: ShipCodeAutomation.ID.self) { automationID in
      AutomationDetailView(automationID: automationID)
    }
    .refreshable {
      await model.refreshAutomations()
    }
    .overlay {
      if model.isRefreshingAutomations, model.automations.isEmpty {
        ProgressView("Loading automations")
      } else if model.automations.isEmpty {
        ContentUnavailableView(
          "No Automations",
          systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
          description: Text("Paired desktop automations will appear here.")
        )
      }
    }
  }
}

private struct AutomationRow: View {
  let automation: ShipCodeAutomation

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(automation.name)
          .font(.headline)
          .lineLimit(2)
        Spacer(minLength: 8)
        Image(systemName: automation.enabled ? "checkmark.circle.fill" : "pause.circle")
          .foregroundStyle(automation.enabled ? .green : .secondary)
          .accessibilityLabel(automation.enabled ? "Enabled" : "Paused")
      }

      Text(automation.projectNames.joined(separator: ", "))
        .font(.subheadline)
        .foregroundStyle(.secondary)

      Text(automation.schedule)
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    .padding(.vertical, 3)
    .accessibilityElement(children: .combine)
  }
}

#Preview {
  NavigationStack {
    AutomationsView()
  }
  .environment(AppModel.preview)
}
