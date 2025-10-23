#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v node &>/dev/null; then
	echo "This env doesn't included nodejs"
	exit 1
fi

if command -v terser &>/dev/null; then
	echo "Terser is already installed"
	exit 0
fi

sudo npm i -g terser

echo "Terser installed successfully"
