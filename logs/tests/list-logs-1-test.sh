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
. ../lib/configurator.sh  || { 
  echo >&2 "Failed loading configurator library." ; exit 1 ; 
}


rerun() {
    command $RERUN -M $RERUN_MODULES "$@"
}

# The Plan
# --------
describe "list-logs"
test_all_log_path_exists(){
	output=$1
	log_paths=$(echo  "$output" | grep ":" | awk '{print $NF}')

	#check every log path points to an existing folder
	for log_path in $log_paths; do
		[ -d "$log_path" ] || return 1
	done
}

it_list_all_logs_from_machine_and_container_name() {
	recreate_project_setup "list_log_prj"
	output=$(rerun logs:list-logs --machine_name localhost --container_name container_ad_1)
	test_all_log_path_exists "$output"
}

it_uses_configured_container_machine_name_if_not_passed(){
	recreate_local_project_setup "list_log_prj"
	output=$(rerun logs:list-logs)
	test_all_log_path_exists "$output"
}
it_reads_properties_from_parent_folders(){
	recreate_local_project_setup "list_log_prj"
	cd logs
	output=$(rerun logs:list-logs)
	test_all_log_path_exists "$output"
}

it_fails_when_properties_not_passed_and_no_ccadmin_properties() {
	recreate_project_setup "list_log_prj"

	$(rerun logs:list-logs) || return 0
	return 1
}


# ------------------------------

