#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if command -v yazi &>/dev/null; then
	echo "Yazi is already installed"
	exit 0
if

YAZI_VERSION="v25.5.31"
ZIPFILE="yazi-x86_64-unknown-linux-gnu.zip"
DIRNAME="yazi-x86_64-unknown-linux-gnu"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/yazi"
DOWNLOAD_URL="https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/${ZIPFILE}"

echo "Updating package lists..."
sudo apt update

echo "Installing 'file' package if not already installed..."
if ! dpkg -s file &>/dev/null; then
	sudo apt install -y file
else
	echo "'file' is already installed."
fi

echo "Downloading Yazi $YAZI_VERSION..."
curl -LO "$DOWNLOAD_URL"

unzip -o "$ZIPFILE"
mkdir -p "$INSTALL_DIR"
mv -f "$DIRNAME/yazi" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

rm -rf "$ZIPFILE" "$DIRNAME"

echo "Yazi installed successfully at $INSTALL_PATH"
