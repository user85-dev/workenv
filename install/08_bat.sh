#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if command -v batcat &>/dev/null || command -v bat &>/dev/null; then
  echo "bat is already installed"
  exit 0
fi

sudo apt-get update
sudo apt-get install -y bat

if command -v batcat &>/dev/null; then
  aliases='batcat'
else
  aliases='bat'
fi

echo "alias bat='$aliases'" >>"$HOME/.bash_aliases"
