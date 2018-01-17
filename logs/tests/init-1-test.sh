#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m logs -p init [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh
[[ -f ../lib/functions.sh ]] && . ../lib/functions.sh init

# The Plan
# --------
#describe "init"
before(){
	test_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	gt_project="${test_folder}/gt_project"
	mkdir -p gt_project
	cd "$gt_project"
}
after(){
	rm -rf "$gt_project"
}
# ------------------------------
# Replace this test. 


it_fails_when_read_config_without_init(){
  error="Project has not being initialized. Run init before read configuration"
	assert_prints_error "read_configuration" "$error"
}

it_is_configured_when_read_config_after_init(){
	rerun logs: init
	#variables has not being initialize yet
	test -z "$PROCESS_LOGS"
	read_configuration
	test -n "$PROCESS_LOGS" -a "$PROCESS_LOGS" = "$gt_project/logs/localhost-container_ad_1/cre/session/process"
}

it_reads_config_from_any_child_folder_within_project(){
	mkdir -p bin/dev
	rerun logs: init
	local pwd
	pwd=$(pwd)
	parent=${pwd%/*}
	while [ ! -z "$parent" ]; do
		echo "$parent"
		parent=${parent%/*}
	  [[ -d $parent/.gt ]] && read_configuration && return 0
	done
	return 1
}

# ------------------------------

