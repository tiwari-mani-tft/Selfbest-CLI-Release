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
BIN="selfbest"
URL="https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/$ARCHIVE"

echo "Downloading $ARCHIVE..."
curl -fL "$URL" -o "$ARCHIVE"

echo "Extracting..."
tar -xzf "$ARCHIVE"

chmod +x "$BIN"
sudo mv "$BIN" /usr/local/bin/selfbest

rm -f "$ARCHIVE"

echo "Installation complete"
selfbest version
