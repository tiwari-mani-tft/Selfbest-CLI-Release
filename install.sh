#!/bin/bash
set -e

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

case "$OS" in
  linux) OS="linux" ;;
  darwin) OS="darwin" ;;
  *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

ARCHIVE="selfbest-$OS-$ARCH.tar.gz"
URL="https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/$ARCHIVE"

TMP_DIR="$(mktemp -d)"

echo "Downloading $ARCHIVE..."
curl -fL "$URL" -o "$TMP_DIR/$ARCHIVE"

echo "Extracting..."
tar -xzf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR"

# Find the extracted binary (assuming the binary is named 'selfbest')
BINARY_PATH=$(find "$TMP_DIR" -type f -name "selfbest*" | head -n 1)

chmod +x "$BINARY_PATH"
sudo mv "$BINARY_PATH" /usr/local/bin/selfbest

rm -rf "$TMP_DIR"

echo "Installation complete"
selfbest version
