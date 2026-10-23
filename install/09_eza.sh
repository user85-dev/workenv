#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if command -v eza &>/dev/null; then
  echo "eza is already installed"
  exit 0
fi

sudo apt-get update
sudo apt-get install -y eza
