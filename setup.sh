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

failed=()
pids=()

run_script() {
	local url="$1"
	local filename
	filename=$(basename "$url")

	echo "Running $filename ..."

	set +e
	timeout 30s bash -c "curl -fsSL '$url' | bash" >/dev/null 2>&1
	status=$?
	set -e

	if [ $status -eq 0 ]; then
		echo "$filename completed."
	else
		if [ $status -eq 124 ]; then
			echo "$filename timeout."
		else
			echo "$filename failed."
		fi
		echo "$filename" >>/tmp/failed_scripts.$$
	fi
}

tmp_failed="/tmp/failed_scripts.$$"
: >"$tmp_failed"

for url in $SCRIPTS; do
	# run in background
	run_script "$url" &
	pids+=($!)

	# limit concurrency
	if [ "${#pids[@]}" -ge "$MAX_JOBS" ]; then
		wait -n
		# cleanup finished pids
		new_pids=()
		for pid in "${pids[@]}"; do
			if kill -0 "$pid" 2>/dev/null; then
				new_pids+=("$pid")
			fi
		done
		pids=("${new_pids[@]}")
	fi
done

# wait remaining jobs
wait

# collect failures
if [[ -f "$tmp_failed" ]]; then
	mapfile -t failed <"$tmp_failed"
	rm -f "$tmp_failed"
fi

echo "----"
if [ ${#failed[@]} -ne 0 ]; then
	echo "Failed scripts:"
	printf '%s\n' "${failed[@]}"
fi

echo "Setup complete!"
