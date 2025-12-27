#!/bin/bash
set -e

REPO="kha-javed-tft/Selfbest_user_cli"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: $ARCH" && exit 1 ;;
esac

case "$OS" in
  linux) OS="linux" ;;
  darwin) OS="darwin" ;;
  *) echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

ARCHIVE="selfbest-$OS-$ARCH.tar.gz"

echo "🔍 Detecting latest STAGING release..."

TAG=$(curl -s "https://api.github.com/repos/$REPO/releases" \
  | grep '"tag_name": "staging-' \
  | head -n1 \
  | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$TAG" ]; then
  echo "❌ No staging release found"
  exit 1
fi

echo "🏷️  Found staging tag: $TAG"

URL="https://github.com/$REPO/releases/download/$TAG/$ARCHIVE"

echo "⬇️  Downloading $ARCHIVE"
curl -fL "$URL" -o "$ARCHIVE"

echo "📦 Extracting..."
tar -xzf "$ARCHIVE"

BIN="selfbest-$OS-$ARCH"
chmod +x "$BIN"

sudo mv "$BIN" /usr/local/bin/selfbest-staging
rm -f "$ARCHIVE"

echo "⚠️  STAGING installation complete"
selfbest-staging version
