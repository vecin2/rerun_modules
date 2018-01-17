# Shell functions for the logs module.
#/ usage: source RERUN_MODULE_DIR/lib/functions.sh command
#

# Read rerun's public functions
. $RERUN || {
echo >&2 "ERROR: Failed sourcing rerun function library: \"$RERUN\""
return 1
}

# Check usage. Argument should be command name.
[[ $# = 1 ]] || rerun_option_usage

# Source the option parser script.
#
if [[ -r $RERUN_MODULE_DIR/commands/$1/options.sh ]] 
then
	. $RERUN_MODULE_DIR/commands/$1/options.sh || {
	rerun_die "Failed loading options parser."
}
fi

# - - -
# Your functions declared here.
# - - -
init_variable () { 
	(( $# != 2 )) && {
	printf >&2 'wrong # args should init_variable name and value'
	return 2
}
local var_name=$1 var_value=$2

echo "$var_name=$var_value" > .gt/config.sh
}	# ----------  end of function init_variable  ----------

init () {
	#AD=$(pwd)
	AD=$(pwd)
	mkdir -p .gt
	init_variable "PROCESS_LOGS" "$AD/logs/localhost-container_ad_1/cre/session/process"
	echo  $(pwd)
}	# ----------  end of function init  ----------

read_configuration(){
	echo marcos $(pwd)
	config_file=".gt/config.sh"
	[[ -f $config_file ]] && . $config_file && return 0

	rerun_log error  "Project has not being initialized. Run init before read configuration"
}
testing_stder(){
	echo  >&2  "Holaaaa"
	return 0
}

last_modified_file(){
	echo $(ls $1 -ltr | tail -1 | head -1 | rev | cut -d " " -f1 | rev)
}

