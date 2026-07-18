import SwiftUI

struct SessionDetailView: View {
  let session: ShipCodeSession

  var body: some View {
    List {
      SessionSummarySection(session: session)
      SessionGitHubSection(session: session)

      if let lastError = session.lastError {
        Section("Last error") {
          Text(lastError)
            .foregroundStyle(.red)
            .textSelection(.enabled)
        }
      }
    }
    .navigationTitle("Session")
    .navigationBarTitleDisplayMode(.inline)
  }
}

private struct SessionSummarySection: View {
  let session: ShipCodeSession

  var body: some View {
    Section {
      LabeledContent("Project", value: session.projectName)
      LabeledContent("Model", value: session.model)
      LabeledContent("Cost") {
        Text(session.totalCostUSD, format: .currency(code: "USD"))
      }
      LabeledContent("Updated") {
        Text(session.updatedAt, style: .relative)
      }
    } header: {
      VStack(alignment: .leading, spacing: 10) {
        Text(session.title)
          .font(.title2.weight(.bold))
          .textCase(nil)
        StatusBadge(
          title: session.phase.displayName,
          systemImage: session.phase.symbolName,
          tone: .init(phase: session.phase)
        )
      }
      .padding(.bottom, 8)
    }
  }
}

private struct SessionGitHubSection: View {
  let session: ShipCodeSession

  var body: some View {
    Section("GitHub") {
      if let issueNumber = session.githubIssueNumber {
        LabeledContent("Issue", value: "#\(issueNumber)")
      }
      if let pullRequestNumber = session.githubPullRequestNumber {
        LabeledContent("Pull request", value: "#\(pullRequestNumber)")
      }
      if session.githubIssueNumber == nil, session.githubPullRequestNumber == nil {
        Text("No linked GitHub item")
          .foregroundStyle(.secondary)
      }
    }
  }
}

#Preview {
  NavigationStack {
    SessionDetailView(session: DemoFixtures.sessions[0])
  }
}
