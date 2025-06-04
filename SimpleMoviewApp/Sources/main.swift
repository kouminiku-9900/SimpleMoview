import SwiftUI
import AVKit

@main
struct SimpleMoviewApp: App {
    @StateObject private var player = Player()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(player)
        }
    }
}
