import SwiftUI

@main
struct ShipCodeApp: App {
  @State private var model = AppModel(
    client: DemoShipCodeClient(),
    initialSnapshot: .demo
  )

  var body: some Scene {
    WindowGroup {
      AppTabView()
        .environment(model)
        .task {
          await model.refreshAll()
        }
    }
  }
}
