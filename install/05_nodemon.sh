#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v node &>/dev/null; then
	echo "This env doesn't included nodejs"
	exit 1
fi

if command -v nodemon &>/dev/null; then
	echo "Nodemon is already installed"
	exit 0
fi

sudo npm i -g nodemon

echo "alias node-watch='nodemon --watch src --ext js,pug,json server.js'" >>"$HOME/.bash_aliases"

echo "Nodemon installed successfully, and run with node-watch"
