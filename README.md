# SimpleMoview

<img src="https://raw.githubusercontent.com/ukuleleadventure2/SimpleMoview/main/SimpleMoview.iconset/icon_128x128.png" width="128" height="128" alt="SimpleMoview Icon">

A lightweight, modern macOS 15+ video and music player written in Swift.

SimpleMoview follows the "less is more" philosophy. It's designed to be a fast, no-nonsense player that supports Drag & Drop and standard keyboard shortcuts right out of the box.

## Features

- **Format Support**: Plays standard macOS supported video and audio formats (MP4, MOV, FLAC, MP3, M4A, etc.).
- **Drag & Drop**: Drag files or folders directly onto the player window to create a playlist.
- **Playlist Management**: Automatically sorts files from dropped folders. Supports Shuffle mode.
- **Intuitive Controls**:
    - **Space**: Play / Pause
    - **Arrow Keys**: Seek Forward / Backward (5s / 10s)
    - **Cmd + Right/Left**: Next / Previous Track
- **System Integration**: Native macOS appearance with a sleek, glassmorphism-inspired design.

## Installation & Building

This project is a **Swift Package**. You can build it easily using the provided script.

### Quick Build (Recommended)
To build the app and create a standalone `.app` bundle:

```bash
./create_app.sh
```

This will generate `SimpleMoview.app` in the project directory and launch it automatically.

### Development (Xcode)
1. Double-click `SimpleMoviewApp/Package.swift` to open the project in Xcode.
2. Press `Cmd + R` to build and run the app for debugging.

## Requirements

- macOS 15.0 or later

## License

MIT License
