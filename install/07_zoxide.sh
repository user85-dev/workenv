#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v zoxide &>/dev/null; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

if ! grep -q 'zoxide init bash' "$HOME/.bashrc"; then
  echo 'eval "$(zoxide init bash)"' >>"$HOME/.bashrc"
fi
