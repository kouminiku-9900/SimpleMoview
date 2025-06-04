# SimpleMoview

A lightweight macOS 15+ video and music player written in Swift and built with Xcode.

## Requirements

- macOS 15 or later.
- Support for MP4 (audio only) and FLAC files.
- Play/Pause, 5‑second forward/back, 10‑second forward/back, next/previous track via keyboard shortcuts matching YouTube.
- Jump to a percentage of the track with number keys 0‑9 (e.g. 1 jumps to 10%).
- Integration with macOS system play/pause controls.
- Folder selection builds a playlist of all contained files sorted alphanumerically.
- Ability to shuffle playlist order.

## Building

Open `SimpleMoviewApp/Package.swift` in Xcode and build the "SimpleMoviewApp" target. You can also run it with `swift run` on macOS 15 or later.

## Todo

- [x] Create Xcode project targeting macOS 15 or later.
- [ ] Implement basic audio/video playback engine in Swift.
- [ ] Add file format handling for MP4 (audio only) and FLAC.
- [ ] Map keyboard shortcuts to YouTube‑style controls (space, arrow keys, 1‑0, etc.).
- [ ] Implement previous/next track and playlist handling.
- [ ] Provide folder picker that loads files and sorts them alphabetically/numerically.
- [ ] Add shuffle toggle for playlist playback.
- [ ] Hook into macOS media key events for play/pause.
- [ ] Build a simple user interface to display current track and playlist.
- [ ] Add unit tests or UI tests where feasible.
