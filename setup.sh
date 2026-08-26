#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

API_URL="https://api.github.com/repos/user85-dev/workenv/contents/install?ref=master"
MAX_JOBS=3

echo "Fetching list of install scripts from GitHub API..."
SCRIPTS=$(curl -sSL "$API_URL" |
	jq -r '.[] | select(.name | endswith(".sh")) | .download_url' | sort)

if [[ -z "$SCRIPTS" ]]; then
	echo "No install scripts found in install folder."
	exit 1
fi

echo "Running install scripts..."

tmp_failed="/tmp/failed_scripts.$$"
: >"$tmp_failed"

run_script() {
	local url="$1"
	local filename
	filename=$(basename "$url")
	echo "Running $filename ..."
	if timeout 30s bash -c "curl -fsSL '$url' | bash" >/tmp/log.$$."$filename" 2>&1; then
		echo "$filename completed."
	else
		status=$?
		if [ "$status" -eq 124 ]; then
			echo "$filename timeout."
		else
			echo "$filename failed."
		fi
		echo "$filename" >>"$tmp_failed"
	fi
}

job_count=0
for url in $SCRIPTS; do
	run_script "$url" &
	job_count=$((job_count + 1))
	if [ "$job_count" -ge "$MAX_JOBS" ]; then
		wait -n
		job_count=$((job_count - 1))
	fi
done
wait

failed=()
if [[ -s "$tmp_failed" ]]; then
	mapfile -t failed <"$tmp_failed"
fi
rm -f "$tmp_failed"

echo "----"
if [ ${#failed[@]} -ne 0 ]; then
	echo "Failed scripts:"
	printf '%s\n' "${failed[@]}"
fi

echo "Setup complete!"

exec bash
