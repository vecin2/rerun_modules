#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m logs -p find [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

# The Plan
# --------
describe "find"

rerun() {
    command $RERUN -M $RERUN_MODULES "$@"
}

before(){
	example_logs_path="./logs/examples"
	mkdir -p $example_logs_path
  touch $example_logs_path/example_older.log
	touch $example_logs_path/example_newer.log
}

after(){
	rm -rf ./logs 
}

# ------------------------------
# Replace this test. 
it_finds_last_modified_by_default() {
	last_modified_file=$($RERUN logs: find --folder $example_logs_path)
	test "example_newer.log" == "$last_modified_file"
}
it_finds_by_log_by_name(){
	last_modified_file=$($RERUN logs: find --folder $example_logs_path --name older)
	test "example_older.log" == "$last_modified_file" 
}
# ------------------------------

