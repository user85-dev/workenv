#!/bin/bash

CONFIG_YAZI="$HOME/.config/yazi"

CONFIG_NVIM="$HOME/.config/nvim"
CACHE_NVIM="$HOME/.cache/nvim"
LOCAL_SHARE_NVIM="$HOME/.local/share/nvim"
LOCAL_STATE_NVIM="$HOME/.local/state/nvim"

BASH_ALIASES_PATH="$PROGRAMMING_PATH/Projects/dotfiles/config/.aliases"
VIMRC_PATH="$HOME/.vimrc"

SCRIPT_DIR="$HOME/Documents/Programming/Workbench/connect-coder"
CONNECT_CODER_PATH="$SCRIPT_DIR"
WORKENV_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
ENV_FILE="$WORKENV_DIR/.env"
source "$SCRIPT_DIR/modules/select_coder_env.sh"

select_environment 1

ssh "$SSH_HOST" <<EOF
mkdir -p ~/.config ~/.cache ~/.local/share ~/.local/state
EOF

rsync -avzL --delete "$CONFIG_YAZI" "$SSH_HOST:~/.config/"
rsync -avzL --delete "$CONFIG_NVIM" "$SSH_HOST:~/.config/"
# rsync -avz --delete "$CACHE_NVIM" "$SSH_HOST:~/.cache/"
# rsync -avz --delete "$LOCAL_SHARE_NVIM" "$SSH_HOST:~/.local/share/"
# rsync -avz --delete "$LOCAL_STATE_NVIM" "$SSH_HOST:~/.local/state/"

scp "$BASH_ALIASES_PATH" "$SSH_HOST:~/.bash_aliases"
scp "$VIMRC_PATH" "$SSH_HOST:~/.vimrc"

if [[ -f "$ENV_FILE" ]]; then
	scp "$ENV_FILE" "$SSH_HOST:~/.env"
else
	echo "No $ENV_FILE, skipping .env copy."
fi

echo "Configs copied to $SSH_HOST"

env_index=1
for key in "${KEYS[@]}"; do
	[[ "$key" == "$SELECTED_CODER" ]] && break
	((env_index++))
done

exec "$CONNECT_CODER_PATH/connect_coder.sh" -e "$env_index" -np
