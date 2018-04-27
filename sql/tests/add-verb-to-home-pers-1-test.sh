#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m sql -p add-verb-to-home-pers [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

# The Plan
# --------
describe "add-verb-to-home-pers"

rr() {
    command "$RERUN" -M "$RERUN_MODULES" "$@"
}
# ------------------------------
# Replace this test. 
it_fails_without_a_real_test() {

	rr sql: add-verb-to-home-pers


    
}
# ------------------------------

