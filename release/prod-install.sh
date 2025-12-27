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
URL="https://github.com/kha-javed-tft/Selfbest_user_cli/releases/latest/download/$ARCHIVE"

echo "Downloading Selfbest CLI (PROD)..."
curl -fL "$URL" -o "$ARCHIVE"

echo "Extracting..."
tar -xzf "$ARCHIVE"

BIN="selfbest-$OS-$ARCH"
chmod +x "$BIN"

sudo mv "$BIN" /usr/local/bin/selfbest
rm -f "$ARCHIVE"

echo "✅ Production installation complete"
selfbest version
