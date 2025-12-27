#!/bin/bash

APP_NAME="SimpleMoview"
SOURCE_DIR="SimpleMoviewApp"
BUILD_DIR="${SOURCE_DIR}/.build/release"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "🚧 Building ${APP_NAME} in release mode..."
cd "${SOURCE_DIR}"
swift build -c release
if [ $? -ne 0 ]; then
    echo "❌ Build failed."
    exit 1
fi
cd ..

echo "📦 Creating .app bundle structure..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Copy the binary
cp "${BUILD_DIR}/SimpleMoviewApp" "${MACOS_DIR}/${APP_NAME}"

# Copy App Icon
if [ -f "AppIcon.icns" ]; then
    cp "AppIcon.icns" "${RESOURCES_DIR}/"
fi

# Create Info.plist
cat > "${CONTENTS_DIR}/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.ukuleleadventure2.${APP_NAME}</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>15.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

# Remove quarantine attribute
xattr -cr "${APP_BUNDLE}"

echo "✅ Created ${APP_BUNDLE}"
echo "✅ Created ${APP_BUNDLE}"
echo "🚀 Launching ${APP_NAME}..."
open "${APP_BUNDLE}"
