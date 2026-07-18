import SwiftUI

struct IssueDetailView: View {
  @Environment(AppModel.self) private var model
  @State private var isShowingMoveDialog = false

  let issueID: ShipCodeIssue.ID

  var body: some View {
    if let issue = model.issue(id: issueID) {
      List {
        IssueHeaderSection(issue: issue)
        IssueMetadataSection(issue: issue)

        Section {
          Button {
            isShowingMoveDialog = true
          } label: {
            Label("Move issue", systemImage: "arrow.left.arrow.right")
          }
          .disabled(model.mutatingIssueIDs.contains(issue.id))
        }
      }
      .navigationTitle("#\(issue.number)")
      .navigationBarTitleDisplayMode(.inline)
      .confirmationDialog(
        "Move issue",
        isPresented: $isShowingMoveDialog,
        titleVisibility: .visible
      ) {
        ForEach(IssueLane.allCases) { lane in
          Button(lane.rawValue) {
            Task {
              await model.moveIssue(id: issue.id, to: lane)
            }
          }
          .disabled(lane == issue.lane)
        }
      } message: {
        Text("The live client will update the GitHub Projects v2 status.")
      }
    } else {
      ContentUnavailableView(
        "Issue unavailable",
        systemImage: "exclamationmark.triangle",
        description: Text("Refresh the issue list and try again.")
      )
    }
  }
}

private struct IssueHeaderSection: View {
  let issue: ShipCodeIssue

  var body: some View {
    Section {
      StatusBadge(
        title: issue.lane.rawValue,
        systemImage: issue.lane.symbolName,
        tone: .init(lane: issue.lane)
      )
    } header: {
      Text(issue.title)
        .font(.title2.weight(.bold))
        .textCase(nil)
        .padding(.bottom, 8)
    }
  }
}

private struct IssueMetadataSection: View {
  let issue: ShipCodeIssue

  var body: some View {
    Section("Details") {
      LabeledContent("Repository", value: issue.repository)
      if let priority = issue.priority {
        LabeledContent("Priority", value: priority)
      }
      if let assignee = issue.assignee {
        LabeledContent("Assignee", value: assignee)
      }
      if let pullRequestNumber = issue.linkedPullRequestNumber {
        LabeledContent("Pull request", value: "#\(pullRequestNumber)")
      }
      if !issue.labels.isEmpty {
        LabeledContent("Labels", value: issue.labels.joined(separator: ", "))
      }
    }
  }
}

#Preview {
  NavigationStack {
    IssueDetailView(issueID: DemoFixtures.issues[0].id)
  }
  .environment(AppModel.preview)
}
