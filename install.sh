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
  linux|darwin) ;;
  *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

ZIP="selfbest-$OS-$ARCH.zip"
URL="https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/$ZIP"

TMP_DIR="$(mktemp -d)"

echo "Downloading Selfbest CLI ($OS/$ARCH)..."
curl -fL "$URL" -o "$TMP_DIR/$ZIP"

echo "Extracting..."
unzip -q "$TMP_DIR/$ZIP" -d "$TMP_DIR"

BIN_PATH="$(find "$TMP_DIR" -type f -maxdepth 1 | head -n 1)"

chmod +x "$BIN_PATH"
sudo mv "$BIN_PATH" /usr/local/bin/selfbest

rm -rf "$TMP_DIR"

echo "Installation complete"
selfbest version
