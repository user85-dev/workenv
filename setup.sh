#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install"

echo "Starting setup..."

if [ ! -d "$INSTALL_DIR" ]; then
	echo "Error: install directory not found: $INSTALL_DIR"
	exit 1
fi

# Find all .sh scripts in install dir, sort, then execute them in order
for script in $(find "$INSTALL_DIR" -maxdepth 1 -name '*.sh' | sort); do
	echo "Running $script ..."
	bash "$script"
	echo "$script completed."
done

echo "All install scripts completed!"
