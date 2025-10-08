#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if command -v lazygit &>/dev/null; then
	echo "Lazygit is already installed"
	exit 0
fi

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]+')

if [[ -z "$LAZYGIT_VERSION" ]]; then
	echo "Failed to fetch latest lazygit version."
	exit 1
fi

echo "Latest LazyGit version: $LAZYGIT_VERSION"

ARCHIVE="lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/${ARCHIVE}"

echo "Downloading $ARCHIVE from $DOWNLOAD_URL..."
curl -Lo lazygit.tar.gz "$DOWNLOAD_URL"

tar -xf lazygit.tar.gz lazygit
sudo install -Dm755 lazygit /usr/local/bin/lazygit

rm -f lazygit lazygit.tar.gz

echo "LazyGit v$LAZYGIT_VERSION installed successfully!"
