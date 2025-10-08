#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

NEOVIM_BUILD="nvim-linux-x86_64"
NEOVIM_VERSION=""

if command -v nvim &>/dev/null; then
	exit
	NEOVIM_VERSION=$(nvim --version | grep -oP '^NVIM \Kv[\d.]+')
else
	NEOVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" |
		grep -Po '"tag_name": *"\Kv[^"]+')
fi

echo "Neovim version to be installed: $NEOVIM_VERSION"

DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/${NEOVIM_BUILD}.tar.gz"
ARCHIVE="${NEOVIM_BUILD}.tar.gz"

echo "Downloading Neovim from: $DOWNLOAD_URL"

if [ ! -s "$ARCHIVE" ]; then
	curl -LO "$DOWNLOAD_URL"
else
	echo "$ARCHIVE already exists, skipping download."
fi

if [ -d "$NEOVIM_BUILD" ]; then
	echo "Removing existing directory $NEOVIM_BUILD"
	rm -rf "$NEOVIM_BUILD"
fi

tar -xzf "$ARCHIVE"
rm "$ARCHIVE"

mv -f "$NEOVIM_BUILD/bin/nvim" "$HOME/.local/bin/nvim"

echo "Neovim $NEOVIM_VERSION downloaded"
