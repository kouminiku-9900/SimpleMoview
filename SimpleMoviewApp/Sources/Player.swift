import AppKit
import SwiftUI
import AVFoundation
import Combine

final class Player: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentIndex = 0
    @Published private(set) var isShuffled = false
    @Published private(set) var playlist: [URL] = []

    @Published var player: AVPlayer?
    private var playerItemContext = 0

    var currentFilename: String {
        guard playlist.indices.contains(currentIndex) else { return "" }
        return playlist[currentIndex].lastPathComponent
    }

    func loadFolder(from result: Result<URL, Error>) {
        guard case let .success(url) = result else { return }
        
        // Security-scoped access
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }

        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)

        if isDirectory.boolValue {
            guard let contents = try? FileManager.default.contentsOfDirectory(
                at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            else { return }
            let supportedExtensions = Set(["mp3", "m4a", "aac", "flac", "wav", "mp4", "mov", "m4v"])
            playlist = contents
                .filter { supportedExtensions.contains($0.pathExtension.lowercased()) }
                .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
        } else {
            // Single file selected
            playlist = [url]
        }
        
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

    private var itemObserver: AnyCancellable?

    func startCurrent() {
        guard playlist.indices.contains(currentIndex) else { return }
        
        // Stop observing previous item
        itemObserver?.cancel()
        
        let item = AVPlayerItem(url: playlist[currentIndex])
        
        // Setup observation for auto-advance
        itemObserver = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .sink { [weak self] _ in
                self?.next()
            }
            
        if player == nil {
            player = AVPlayer(playerItem: item)
        } else {
            player?.replaceCurrentItem(with: item)
        }
        
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
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if self?.handleEvent(event) == true {
                return nil
            }
            return event
        }
    }

    private func handleEvent(_ event: NSEvent) -> Bool {
        // Prioritize key codes for special keys
        switch event.keyCode {
        case 49: // Space
            togglePlayPause()
            return true
        case 123: // Left Arrow
            step(by: -5)
            return true
        case 124: // Right Arrow
            step(by: 5)
            return true
        default:
            break
        }

        guard let characters = event.charactersIgnoringModifiers else { return false }
        switch characters {
        case "l":
            step(by: 10)
            return true
        case "j":
            step(by: -10)
            return true
        case "k":
            togglePlayPause()
            return true
        case "n":
            next()
            return true
        case "p":
            previous()
            return true
        case "1"..."9", "0":
            if let value = Int(characters) {
                jumpTo(percent: Double(value) / 10.0)
                return true
            } else if characters == "0" {
                jumpTo(percent: 0)
                return true
            }
        default:
            break
        }
        return false
    }

    func step(by seconds: Double) {
        guard let player = player else { return }
        let current = player.currentTime().seconds
        let newTime = max(0, current + seconds)
        let time = CMTime(seconds: newTime, preferredTimescale: 1)
        player.seek(to: time)
    }
}
