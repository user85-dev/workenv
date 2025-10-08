#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

API_URL="https://api.github.com/repos/user85-dev/workenv/contents/install?ref=master"

echo "Fetching list of install scripts from GitHub API..."
SCRIPTS=$(curl -sSL "$API_URL" |
	jq -r '.[] | select(.name | endswith(".sh")) | .download_url' | sort)

if [[ -z "$SCRIPTS" ]]; then
	echo "No install scripts found in install folder."
	exit 1
fi

echo "Running install scripts..."

for url in $SCRIPTS; do
	filename=$(basename "$url")
	echo "Running $filename ..."
	curl -sSL "$url" | bash
	echo "$filename completed."
done

echo "Setup complete!"
