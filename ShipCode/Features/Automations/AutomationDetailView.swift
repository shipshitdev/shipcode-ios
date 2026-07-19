import SwiftUI

struct AutomationDetailView: View {
  @Environment(AppModel.self) private var model

  let automationID: ShipCodeAutomation.ID

  var body: some View {
    if let automation = model.automation(id: automationID) {
      List {
        AutomationSummarySection(automation: automation)
        AutomationScheduleSection(automation: automation)

        Section {
          Button {
            Task {
              await model.runAutomation(id: automation.id)
            }
          } label: {
            Label("Run now", systemImage: "play.fill")
          }
          .disabled(model.mutatingAutomationIDs.contains(automation.id))

          Button {
            Task {
              await model.setAutomationEnabled(
                id: automation.id,
                enabled: !automation.enabled
              )
            }
          } label: {
            Label(
              automation.enabled ? "Pause automation" : "Enable automation",
              systemImage: automation.enabled ? "pause.fill" : "checkmark"
            )
          }
          .disabled(model.mutatingAutomationIDs.contains(automation.id))
        }
      }
      .navigationTitle("Automation")
      .navigationBarTitleDisplayMode(.inline)
    } else {
      ContentUnavailableView(
        "Automation unavailable",
        systemImage: "exclamationmark.triangle",
        description: Text("Refresh the automation list and try again.")
      )
    }
  }
}

private struct AutomationSummarySection: View {
  let automation: ShipCodeAutomation

  var body: some View {
    Section {
      LabeledContent("State", value: automation.enabled ? "Enabled" : "Paused")
      LabeledContent("Projects", value: automation.projectNames.joined(separator: ", "))
      LabeledContent("Runs", value: automation.runCount.formatted())
      if let lastStatus = automation.lastStatus {
        LabeledContent("Last status", value: lastStatus.displayName)
      }
    } header: {
      Text(automation.name)
        .font(.title2.weight(.bold))
        .textCase(nil)
        .padding(.bottom, 8)
    }
  }
}

private struct AutomationScheduleSection: View {
  let automation: ShipCodeAutomation

  var body: some View {
    Section("Schedule") {
      Text(automation.schedule)
      if let lastStartedAt = automation.lastStartedAt {
        LabeledContent("Last run") {
          Text(lastStartedAt, style: .relative)
        }
      }
      if let nextRunAt = automation.nextRunAt {
        LabeledContent("Next run") {
          Text(nextRunAt, style: .relative)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    AutomationDetailView(automationID: DemoFixtures.automations[0].id)
  }
  .environment(AppModel.preview)
}
