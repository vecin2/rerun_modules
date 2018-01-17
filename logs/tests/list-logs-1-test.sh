#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m logs -p list-logs [--answers <>]
#


# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh
. $RERUN_MODULE_DIR/lib/functions.sh list-logs || { 
  echo >&2 "Failed loading function library." ; exit 1 ; 
}


rerun() {
    command $RERUN -M $RERUN_MODULES "$@"
}

# The Plan
# --------
describe "list-logs"

it_list_all_logs() {
	output=$(rerun logs:list-logs)
  path=${output##*[[:space:]]} 
	[ -d "$path" ] && return 0

	return 1
}

# ------------------------------

