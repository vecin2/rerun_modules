#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m config -p init [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh
#[[ -f ../commands/init/script ]] && . ../commands/init/script
[[ -f ../lib/functions.sh ]] && . ../lib/functions.sh init


# The Plan
# --------
describe "init"
shopt -s expand_aliases

rr() {
    command "$RERUN" -M "$RERUN_MODULES" "$@"
}


# ------------------------------
# Replace this test. 
it_initialize_file_passed() {
	test_default_config_path="${HOME}/.test.em.bash"
	local output_init=$(create_config_file "$test_default_config_path")
	test "$test_default_config_path" == "${output_init}"
}
it_initialize_em_config_file_if_no_file_passed(){
	default_config_path="${HOME}/.em.bash"

	local output_init=$(create_config_file "$test_default_config_path")

	test "$default_config_path" == "${output_init}"
}
it_overrides_em_core_home() {
	test_default_config_path="$HOME/testi.em.bash"
	local project_name="test_config_dir"
	mkdir -p $project_name
  cd $project_name
	project_path=$(pwd)

	create_config_file "$test_default_config_path"

	. "$test_default_config_path"

	test "$project_path" == "$EM_CORE_HOME"
}

it_configures_log_paths() {
	test_default_config_path="$HOME/.test.em.bash"
	local project_name="test_config_log_paths"
	rm -rf "$project_name"
	mkdir -p $project_name
  cd $project_name
	local project_path=$(pwd)

	create_config_file "$test_default_config_path"

	. "$test_default_config_path"

	test "$project_path" == "$EM_CORE_HOME"

	test "$project_path/logs/ad/cre/session/process" == "$EM_PROCESS_LOGS"
}

it_sets_ad_shorcut(){
	test_default_config_path="$HOME/.test_sets_ad_shorcut.em.bash"
	create_config_file "$test_default_config_path"
	. "$test_default_config_path"
	
	tad

	test "$EM_CORE_HOME" == $(pwd)
}
# ------------------------------


