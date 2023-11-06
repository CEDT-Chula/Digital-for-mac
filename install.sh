#!/bin/bash
DOWNLOAD_URL="https://github.com/hneemann/Digital/releases/download/v0.30/Digital.zip"
ZIP_NAME="Digital.zip"
APP_NAME="Digital"
OUTPUT_NAME="Digital.dmg"

if ! type -p java &>/dev/null || ! type -p jpackage &>/dev/null; then
    echo "Java Development Kit not found. Installing JDK via Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install --cask temurin
fi

echo "Downloading $ZIP_NAME from $DOWNLOAD_URL..."
curl -L $DOWNLOAD_URL -o $ZIP_NAME

echo "Unzipping $ZIP_NAME..."
unzip -o $ZIP_NAME -d Digital

cd Digital

JAR_NAME=$(find . -name "*.jar")

if [ -z "$JAR_NAME" ]; then
    echo "Failed to find a JAR file in the extracted contents."
    exit 1
fi
echo "Creating DMG package..."
jpackage --input . \
  --name "$APP_NAME" \
  --main-jar "$JAR_NAME" \
  --type dmg \
  --java-options '--enable-preview' \
  --app-version "1.0" 

if [ -f "${APP_NAME}-1.0.dmg" ]; then
    mv "${APP_NAME}-1.0.dmg" "$OUTPUT_NAME"
    echo "DMG package created successfully: $OUTPUT_NAME"
else
    echo "Failed to create DMG package."
    exit 1
fi

echo "Cleaning up..."
cd ..
rm -rf Digital $ZIP_NAME

echo "Process completed successfully."
