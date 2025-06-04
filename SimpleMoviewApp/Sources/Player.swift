import AppKit
import SwiftUI
import AVFoundation

final class Player: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentIndex = 0
    @Published private(set) var isShuffled = false
    @Published private(set) var playlist: [URL] = []

    private var player: AVPlayer?
    private var playerItemContext = 0

    var currentFilename: String {
        guard playlist.indices.contains(currentIndex) else { return "" }
        return playlist[currentIndex].lastPathComponent
    }

    func loadFolder(from result: Result<URL, Error>) {
        guard case let .success(url) = result else { return }
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        else { return }
        playlist = contents.sorted { $0.lastPathComponent < $1.lastPathComponent }
        currentIndex = 0
        startCurrent()
    }

    func toggleShuffle() {
        isShuffled.toggle()
        if isShuffled {
            playlist.shuffle()
        } else {
            playlist.sort { $0.lastPathComponent < $1.lastPathComponent }
        }
    }

    func startCurrent() {
        guard playlist.indices.contains(currentIndex) else { return }
        let item = AVPlayerItem(url: playlist[currentIndex])
        player = AVPlayer(playerItem: item)
        player?.play()
        isPlaying = true
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func next() {
        guard !playlist.isEmpty else { return }
        currentIndex = (currentIndex + 1) % playlist.count
        startCurrent()
    }

    func previous() {
        guard !playlist.isEmpty else { return }
        currentIndex = (currentIndex - 1 + playlist.count) % playlist.count
        startCurrent()
    }

    private func seek(seconds: Double) {
        guard let player = player else { return }
        let time = CMTime(seconds: seconds, preferredTimescale: 1)
        player.seek(to: time)
    }

    func jumpTo(percent: Double) {
        guard let player = player, let duration = player.currentItem?.duration.seconds,
              duration.isFinite else { return }
        let time = CMTime(seconds: duration * percent, preferredTimescale: 1)
        player.seek(to: time)
    }

    func setupKeyCommands() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.handleEvent($0)
            return $0
        }
    }

    private func handleEvent(_ event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }
        switch characters {
        case " " :
            togglePlayPause()
        case "l" :
            step(by: 5)
        case "j" :
            step(by: -5)
        case "n" :
            next()
        case "p" :
            previous()
        case "1"..."9", "0":
            if let value = Int(characters) {
                jumpTo(percent: Double(value) / 10.0)
            } else if characters == "0" {
                jumpTo(percent: 0)
            }
        default:
            break
        }
    }

    func step(by seconds: Double) {
        guard let player = player else { return }
        let current = player.currentTime().seconds
        let newTime = max(0, current + seconds)
        let time = CMTime(seconds: newTime, preferredTimescale: 1)
        player.seek(to: time)
    }
}
