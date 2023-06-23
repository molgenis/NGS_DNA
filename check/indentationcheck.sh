#!/bin/bash

MYDIR="$(cd -P "$(dirname "${0}")" && pwd)"

echo '#####################################################################################'
echo '  Bash code must be indented with TABs. Checking for lines indented with spaces ... '
echo '#####################################################################################'
grep --recursive --line-number --include='*.*sh' --exclude-dir='deprecated' '^[[:space:]]* [[:space:]]*' "${MYDIR}"/../
grep_exit_status="${?}"
if [[ "${grep_exit_status}" -eq 0 ]]; then
	echo '#####################################################################################'
	echo '  ERROR: found Bash files containing lines (partially) indented with spaces.'
	echo '#####################################################################################'
	exit 1
elif [[ "${grep_exit_status}" -eq 1 ]]; then
	echo '  Ok: all Bash files indented with TABs.'
	echo '####################################################################################'
	exit 0
else
	echo '  FAILED: indentation sanity check failed.'
	echo '####################################################################################'
	exit 1
fi
