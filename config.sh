#!/bin/bash

CONFIG_YAZI="$HOME/.config/yazi"

CONFIG_NVIM="$HOME/.config/nvim"
CACHE_NVIM="$HOME/.cache/nvim"
LOCAL_SHARE_NVIM="$HOME/.local/share/nvim"
LOCAL_STATE_NVIM="$HOME/.local/state/nvim"

BASH_ALIASES_PATH="$HOME/.bash_aliases"
VIMRC_PATH="$PATH/.vimrc"

SCRIPT_DIR="$HOME/connect-coder"
source "$SCRIPT_DIR/modules/select_coder_env.sh"

select_environment

ssh "$SSH_HOST" <<EOF
mkdir -p ~/.config ~/.cache ~/.local/share ~/.local/state
EOF

rsync -avz --delete "$CONFIG_YAZI" "$SSH_HOST:~/.config/"
rsync -avz --delete "$CONFIG_NVIM" "$SSH_HOST:~/.config/"
rsync -avz --delete "$CACHE_NVIM" "$SSH_HOST:~/.cache/"
rsync -avz --delete "$LOCAL_SHARE_NVIM" "$SSH_HOST:~/.local/share/"
rsync -avz --delete "$LOCAL_STATE_NVIM" "$SSH_HOST:~/.local/state/"

scp "$BASH_ALIASES_PATH" "$SSH_HOST:~/.bash_aliases"
scp "$VIMRC_PATH" "$SSH_HOST:~/.vimrc"

echo "Configs copied to $SSH_HOST"
