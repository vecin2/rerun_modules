#!/bin/bash - 
#===============================================================================
#
#          FILE: api.sh
# 
#         USAGE: ./api.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 13/04/18 18:10
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

vpl(){
	vi $(rr logs: find --folder "$EM_PROCESS_LOGS")
}


