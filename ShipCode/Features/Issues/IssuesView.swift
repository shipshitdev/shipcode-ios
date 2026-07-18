import SwiftUI

struct IssuesView: View {
  @Environment(AppModel.self) private var model

  var body: some View {
    List {
      Section {
        ConnectionBanner(state: model.connectionState)
      }

      ForEach(IssueLane.allCases) { lane in
        if let issues = model.issuesByLane[lane], !issues.isEmpty {
          Section {
            ForEach(issues) { issue in
              NavigationLink(value: issue.id) {
                IssueRow(issue: issue)
              }
            }
          } header: {
            Label(lane.rawValue, systemImage: lane.symbolName)
          }
        }
      }
    }
    .navigationTitle("Issues")
    .navigationDestination(for: ShipCodeIssue.ID.self) { issueID in
      IssueDetailView(issueID: issueID)
    }
    .refreshable {
      await model.refreshIssues()
    }
    .overlay {
      if model.isRefreshingIssues, model.issues.isEmpty {
        ProgressView("Loading issues")
      } else if model.issues.isEmpty {
        ContentUnavailableView(
          "No Issues",
          systemImage: "rectangle.3.group",
          description: Text("Connect GitHub to load ShipCode roadmap issues.")
        )
      }
    }
  }
}

private struct IssueRow: View {
  let issue: ShipCodeIssue

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(issue.title)
        .font(.headline)
        .lineLimit(2)

      HStack(spacing: 6) {
        Text("#\(issue.number)")
          .monospacedDigit()
        if let priority = issue.priority {
          Text("·")
          Text(priority)
        }
        Spacer()
        Text(issue.updatedAt, style: .relative)
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
    IssuesView()
  }
  .environment(AppModel.preview)
}
