#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m sql -p add-verb-to-home-pers [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh
[[ -f ../lib/functions.sh ]] && . ../lib/functions.sh add-verb-to-home-perspective 

# The Plan
# --------
describe "add-verb-to-home-pers"

rr() {
    command "$RERUN" -M "$RERUN_MODULES" "$@"
}
# ------------------------------
# Replace this test. 
it_should_list_all_templates_in_folder() {
	local templates_loc=./test-templates
	mkdir -p $templates_loc
	touch "$templates_loc/add_verb.sql"

	local menu=$(list_sql_templates $templates_loc)

	test "1) add_verb" == "$menu"
    
}
# ------------------------------

