import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var player: Player
    @State private var showingImporter = false

    var body: some View {
        VStack {
            if let avPlayer = player.player {
                VideoPlayer(player: avPlayer)
            } else {
                Spacer()
                Text("No Video Playing")
                Spacer()
            }
            HStack {
                Button("Open File/Folder") { showingImporter = true }
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
            allowedContentTypes: [.folder, .movie, .audio],
            allowsMultipleSelection: false
        ) { result in
            if let urls = try? result.get(), let url = urls.first {
                player.loadFolder(from: .success(url))
            }
        }
        .frame(minWidth: 400, minHeight: 200)
        .onAppear { player.setupKeyCommands() }
    }
}

#Preview {
    ContentView().environmentObject(Player())
}
