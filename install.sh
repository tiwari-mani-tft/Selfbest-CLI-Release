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

BIN="selfbest-$OS-$ARCH"
ZIP="$BIN.zip"
URL="https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/$ZIP"

TMP_DIR="$(mktemp -d)"

echo "Downloading Selfbest CLI ($OS/$ARCH)..."
curl -sSL "$URL" -o "$TMP_DIR/$ZIP"

echo "Extracting..."
unzip -q "$TMP_DIR/$ZIP" -d "$TMP_DIR"

chmod +x "$TMP_DIR/$BIN"
sudo mv "$TMP_DIR/$BIN" /usr/local/bin/selfbest

rm -rf "$TMP_DIR"

echo "Installation complete"
echo "Run: selfbest version"
