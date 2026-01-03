import SwiftUI
import AVKit

@main
struct SimpleMoviewApp: App {
    @StateObject private var player = Player()

    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(player)
        }
    }
}
