#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

NEOVIM_BUILD="nvim-linux-x86_64"
NEOVIM_VERSION=""

if command -v nvim &>/dev/null; then
	echo "Neovim is already installed"
	exit 0
fi

GLIBC_VERSION=$(ldd --version | grep -Po '\b\d+\.\d+\b' | head -n1)
NEOVIM_REPO= ""

if [ "$(printf "%s\n" "$GLIBC_VERSION" "2.41" | sort -V | head -n1)" != "2.41" ]; then
	NEOVIM_REPO="neovim-release"
	echo "Will install the unsupported builds"
else
	NEOVIM_REPO="neovim"
fi

NEOVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/$NEOVIM_REPO/releases/latest" |
	grep -Po '"tag_name": *"\Kv[^"]+')

echo "Neovim version to be installed: $NEOVIM_VERSION"

DOWNLOAD_URL="https://github.com/neovim/$NEOVIM_REPO/releases/download/${NEOVIM_VERSION}/${NEOVIM_BUILD}.tar.gz"
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

mkdir -p "$HOME/.local/nvim"
mv "$NEOVIM_BUILD"/* "$HOME/.local/nvim/"

mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.local/nvim/bin/nvim" "$HOME/.local/bin/nvim"

rm -rf "$NEOVIM_BUILD"

echo "Neovim $NEOVIM_VERSION downloaded"
