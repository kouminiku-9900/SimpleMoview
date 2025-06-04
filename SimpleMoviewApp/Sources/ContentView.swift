import SwiftUI

struct ContentView: View {
    @EnvironmentObject var player: Player
    @State private var showingImporter = false

    var body: some View {
        VStack {
            HStack {
                Button("Open Folder") { showingImporter = true }
                Button(player.isPlaying ? "Pause" : "Play") {
                    player.togglePlayPause()
                }
                Button("Next") { player.next() }
                Button("Previous") { player.previous() }
                Button("Shuffle: \(player.isShuffled ? "On" : "Off")") {
                    player.toggleShuffle()
                }
            }
            Text(player.currentFilename)
                .padding()
        }
        .fileImporter(
            isPresented: $showingImporter,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            player.loadFolder(from: result)
        }
        .frame(minWidth: 400, minHeight: 200)
        .onAppear { player.setupKeyCommands() }
    }
}

#Preview {
    ContentView().environmentObject(Player())
}
