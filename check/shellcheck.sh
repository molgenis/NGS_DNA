#!/bin/bash

#
# Disable some shellcheck warnings:
#  * SC2004: $/${} is unnecessary on arithmetic variables.
#            But for consistency we prefer to always use ${} anyway.
#  * SC2015: Note that A && B || C is not if-then-else. C may run when A is true.
#            We know and use this construct regularly to create "transactions"
#            where C is only executed when both A and B have succeeded.
#  * SC2154: Due to Molgenis Compute string initialization the warning is not valid 
#
#  * SC2148: the shebang is declared in the header.ftl not in the protocols
#

export SHELLCHECK_OPTS="-e SC2004 -e SC2015 -e SC2154 -e SC2148"

function showHelp() {
	#
	# Display commandline help on STDOUT.
	#
	cat <<EOH
===============================================================================================================
Script for sanity checking of Bash code of this repo using ShellCheck.
Usage:
	$(basename "${0}") OPTIONS
Options:
	-h	Show this help.
	-v	Enables verbose output.
===============================================================================================================
EOH
	exit 0
}


#
# Parse commandline options
#
while getopts ":hv" opt
do
	case "${opt}" in
		h)
			showHelp
			;;
		v)
			verbose='1'
			;;
		\?)
			printf '%s\n' "FATAL: Invalid option -${OPTARG}. Try $(basename "${0}") -h for help."
			exit 1
			;;
		:)
			printf '%s\n' "FATAL: Option -${OPTARG} requires an argument. Try $(basename "${0}") -h for help."
			exit 1
			;;
		*)
			printf '%s\n' "FATAL Unhandled option. Try $(basename "${0}") -h for help."
			exit 1
			;;
	esac
done

#
# Check if ShellCheck is installed.
#
which shellcheck 2>&1 >/dev/null \
	|| {
		printf '%s\n' 'FATAL: cannot find shellcheck; make sure it is installed and can be found in ${PATH}.'
		exit 1
	}

#
# Run ShellCheck for all Bash scripts in the bin/ subdir.
#  * Includes sourced files, so the libraries from the lib/ subfolder 
#    are checked too as long a they are used in at least one script.
#  * Select format and output based on whether this script is 
#    executed by Jenkins or by a regular user.
#
if [[ -n "${WORKSPACE:-}" ]]
then
	#
	# Exclude SC2154 (warning for variables that are referenced but not assigned),
	# because we cannot easily resolve variables sourced from etc/*.cfg config files.
	#
	export SHELLCHECK_OPTS="${SHELLCHECK_OPTS} -e SC2154"
	#
	# ShellCheck for Jenkins.
	#
	shellcheck -a -x -o all -f checkstyle "${WORKSPACE}"/protocols/*.sh | tee checkstyle-result.xml
	#
	# Reformat the generated report to add hyperlinks to the ShellCheck issues on the wiki:
	#	https://github.com/koalaman/shellcheck/wiki/SC${ISSUENUMBER}
	# explaining what is wrong with the code / style and how to improve it.
	#
	perl -pi -e "s|message='([^']+)'\s+source='ShellCheck.(SC[0-9]+)'|message='&lt;a href=&quot;https://github.com/koalaman/shellcheck/wiki/\$2&quot;&gt;\$2: \$1&lt;/a&gt;' source='ShellCheck.\$2'|" checkstyle-result.xml
else
	#
	# ShellCheck for regular user on the commandline.
	#
	MYDIR="$(cd -P "$(dirname "${0}")" && pwd)"
	if [[ "${verbose:-0}" -eq 1 ]]
	then
		cd "${MYDIR}/.."
		shellcheck -a -x -o all -f tty protocols/*.sh # cannot use the printf construct used below for non-vebose output as it destroys the terminal colors.
		cd '-' # Goes back to previous directory before we changed to ${MYDIR}.
	else
		printf '%s\n' "$(cd "${MYDIR}/.." && shellcheck -a -x -o all -f gcc protocols/*.sh)"
	fi
fi
