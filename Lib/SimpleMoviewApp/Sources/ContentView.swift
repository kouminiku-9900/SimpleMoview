import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var player: Player
    @State private var showingImporter = false

    var body: some View {
        VStack(spacing: 0) {
            // Layer 1: Content (Video or Artwork)
            ZStack {
                if player.hasVideo, let avPlayer = player.player {
                    VideoPlayer(player: avPlayer)
                } else if player.player == nil {
                    Text("No Video Playing")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if !player.hasVideo, let artwork = player.currentArtwork {
                    Image(nsImage: artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Layer 2: Controls Area
            VStack(spacing: 8) {
                Text(player.currentFilename)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.horizontal)

                // Progress Bar (Only for Audio/Artwork mode)
                if !player.hasVideo {
                    HStack(spacing: 12) {
                        Text(formatTime(player.currentTime))
                            .font(.caption)
                            .monospacedDigit()
                        
                        Slider(value: Binding(
                            get: { player.currentTime },
                            set: { newValue in
                                player.isSeeking = true
                                player.currentTime = newValue
                                player.seek(to: newValue)
                            }
                        ), in: 0...max(0.01, player.duration)) { editing in
                            player.isSeeking = editing
                        }
                        .controlSize(.small)
                        
                        Text(formatTime(player.duration))
                            .font(.caption)
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 20)
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
            }
            .padding(.vertical, 20)
            .background(Color(NSColor.windowBackgroundColor))
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
    
    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN, seconds.isFinite else { return "0:00" }
        let totalSeconds = Int(seconds)
        let min = totalSeconds / 60
        let sec = totalSeconds % 60
        return String(format: "%d:%02d", min, sec)
    }
}

#Preview {
    ContentView().environmentObject(Player())
}
