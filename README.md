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

## Todo

1. Create Xcode project targeting macOS 15 or later.
2. Implement basic audio/video playback engine in Swift.
3. Add file format handling for MP4 (audio only) and FLAC.
4. Map keyboard shortcuts to YouTube‑style controls (space, arrow keys, 1‑0, etc.).
5. Implement previous/next track and playlist handling.
6. Provide folder picker that loads files and sorts them alphabetically/numerically.
7. Add shuffle toggle for playlist playback.
8. Hook into macOS media key events for play/pause.
9. Build a simple user interface to display current track and playlist.
10. Add unit tests or UI tests where feasible.
