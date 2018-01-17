#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m logs -p vpl [--answers <>]
#

# Helpers
# -------
echo "current dir is $(pwd)"
[[ -f ./functions.sh ]] && . ./functions.sh
[[ -f ../lib/functions.sh ]] && . ../lib/functions.sh vpl

before(){
	example_logs_path="./logs/examples"
	mkdir -p $example_logs_path
  touch $example_logs_path/example_older.log
	touch $example_logs_path/example_newer.log
}
after(){
	rm -rf ./logs 
}
# The Plan
# --------
describe "vpl"

it_finds_path_to_last_modified_process_log() {
	last_modified_file=$(last_modified_file $example_logs_path)
	[ "example_newer.log" == "$last_modified_file"  ]
}
#it_has_shorcuts_to_different_logs(){
#	init
# 
#	[ "$PROCESS_LOGS" == "/opt/verint/verint_projects/SPEN/FP3/logs/localhost-container_ad_1/cre/session/process" ]
#}
# ------------------------------

