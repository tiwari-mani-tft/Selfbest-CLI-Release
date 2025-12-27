#!/bin/bash
set -e

VERSION="$1"

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

if [ -z "$VERSION" ]; then
  echo "Installing latest PRODUCTION release..."
  URL="https://github.com/kha-javed-tft/Selfbest_user_cli/releases/latest/download/$ARCHIVE"
  TARGET="/usr/local/bin/selfbest"
else
  echo "Installing version: $VERSION"
  URL="https://github.com/kha-javed-tft/Selfbest_user_cli/releases/download/$VERSION/$ARCHIVE"

  if [[ "$VERSION" == staging-* ]]; then
    TARGET="/usr/local/bin/selfbest-staging"
  else
    TARGET="/usr/local/bin/selfbest"
  fi
fi

echo "Downloading from:"
echo "$URL"

curl -fL "$URL" -o "$ARCHIVE"

echo "Extracting..."
tar -xzf "$ARCHIVE"

BIN="selfbest-$OS-$ARCH"
chmod +x "$BIN"

sudo mv "$BIN" "$TARGET"
rm -f "$ARCHIVE"

echo "✅ Installation complete"
"$TARGET" version
