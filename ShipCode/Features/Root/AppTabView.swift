import SwiftUI

struct AppTabView: View {
  enum TabSelection: Hashable {
    case sessions
    case issues
    case automations
  }

  @Environment(AppModel.self) private var model
  @State private var selectedTab = TabSelection.sessions

  var body: some View {
    @Bindable var model = model

    TabView(selection: $selectedTab) {
      Tab("Sessions", systemImage: "bolt.horizontal.circle", value: .sessions) {
        NavigationStack {
          SessionsView()
        }
      }
      .badge(model.activeSessions.count)

      Tab("Issues", systemImage: "rectangle.3.group", value: .issues) {
        NavigationStack {
          IssuesView()
        }
      }

      Tab(
        "Automations", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
        value: .automations
      ) {
        NavigationStack {
          AutomationsView()
        }
      }
    }
    .alert("ShipCode couldn’t complete the request", isPresented: $model.isShowingError) {
      Button("OK") {
        model.dismissError()
      }
    } message: {
      Text(model.errorMessage ?? "Try again.")
    }
  }
}

#Preview {
  AppTabView()
    .environment(AppModel.preview)
}
