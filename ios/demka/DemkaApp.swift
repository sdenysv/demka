import SwiftUI

@main
struct DemkaApp: App {
    @StateObject private var vm = DeckViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .onOpenURL { url in
                    vm.handleIncomingURL(url)
                }
        }
    }
}
