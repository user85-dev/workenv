#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

RIPGREP_VERSION="14.1.1"
PACKAGE="ripgrep_${RIPGREP_VERSION}-1_amd64.deb"
DOWNLOAD_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${PACKAGE}"

echo "Downloading ripgrep version $RIPGREP_VERSION..."
curl -LO "$DOWNLOAD_URL"

sudo dpkg -i "$PACKAGE"

rm -f "$PACKAGE"

echo "ripgrep $RIPGREP_VERSION installed successfully!"
