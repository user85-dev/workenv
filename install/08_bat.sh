#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if command -v batcat &>/dev/null || command -v bat &>/dev/null; then
  echo "bat is already installed"
  exit 0
fi

sudo apt i bat

aliases='batcat'
if command -v bat &>/dev/null; then
  aliases='bat'
fi

echo "alias bat='$aliases'" >>"$HOME/.bash_aliases"
