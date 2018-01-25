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

recreate_folder ()
{
	local gt_project=$1
	[[ -d $gt_project ]] && rm -rf "$gt_project"
	mkdir -p ${gt_project##*/}
}	# ----------  end of function recreate_folder  ----------

before(){
	test_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	gt_project="${test_folder}/gt_project"
	recreate_folder  $gt_project
	#cd "$gt_project"
}
after(){
	cd .
}
# ------------------------------
# Replace this test. 


it_fails_when_read_config_without_init(){
	cd "$gt_project"
	error="Project has not being initialized. Run init in the home directory before read configuration"
	assert_prints_error "read_configuration" "$error"
}

it_is_configured_when_read_config_after_init(){
	cd "$gt_project"
	rerun logs: init --machine_name localhost

	#variables has not being initialize yet
	test -z "${PROCESS_LOGS:=}"

	#after configuration is read variables are initialize
	read_configuration
	test -n "$PROCESS_LOGS" -a "$PROCESS_LOGS" = "$gt_project/logs/localhost-container_ad_1/cre/session/process"
}
create_ccadmin_properties(){
	(( $# != 1 )) && {
	printf >&2 'wrong #args should create_ccadmin_properties project_home'
	return 2
}

	echo  project home is $1
	local project_home ccadmin_config_folder ccadmin_config_file
	project_home=$1
	ccadmin_config_folder=$project_home/config
	ccadmin_config_file=$ccadmin_config_folder/ccadmin.properties
	mkdir $ccadmin_config_folder
	touch $ccadmin_config_file
#	content=$(printf	"ccadmin.machine.name=localhost\nccadmin.environment.name=localdev")
	content=$'ccadmin.machine.name=localhost\nccadmin.environment.name=localdev' 
	echo "$content" > $ccadmin_config_file
	echo "content of fil is" $(cat $ccadmin_config_file)
}

it_init_from_ccadmin_properties_if_not_specified(){
	cd "$gt_project"
	create_ccadmin_properties $gt_project
	rerun logs: init
	read_configuration
	test -n "$PROCESS_LOGS" -a "$PROCESS_LOGS" = "$gt_project/logs/localhost-container_ad_1/cre/session/process"
}

it_fails_when_init_variable_wrong_args(){
	set +e
	output=$(init_variable)
  expected=$(rerun_color red "wrong")
	set -e
}
it_reads_config_from_any_child_folder_within_project(){
	cd "$gt_project"
	create_ccadmin_properties $gt_project
	rerun logs: init
	mkdir -p bin/dev
	cd "$gt_project/bin/dev"
	#variables has not being initialize yet
	test -z "${PROCESS_LOGS:=}"
	read_configuration
	test -n "$PROCESS_LOGS" -a "$PROCESS_LOGS" = "$gt_project/logs/localhost-container_ad_1/cre/session/process"
}



# ------------------------------

