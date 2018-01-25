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
	if [ $# != 3 ]; then
		rerun_args_error "name" "value" "file"
		return 2
	fi

local var_name=$1 var_value=$2 file=$3
echo "$var_name=$var_value" > $file
}	# ----------  end of function init_variable  ----------
read_property_value(){
	if [ "$#" != "2" ]; then
		rerun_args_error "property_name" "file"
	fi
	machine_line=$(grep "ccadmin.machine.name" $ccadmin_properties_file)
	MACHINE_NAME=${machine_line##*=}
	MACHINE_NAME=$(echo $MACHINE_NAME|tr -d '\r')
}
init_ccadmin_properties(){
	[[ -n $MACHINE_NAME ]] && return 0
	local ccadmin_properties_file machine_line
	ccadmin_properties_file=$AD/config/ccadmin.properties
	read_property_value 
}
init () {
	AD=$(pwd)
	mkdir -p .gt
	init_ccadmin_properties
	init_variable "PROCESS_LOGS" "$AD/logs/${MACHINE_NAME}-container_ad_1/cre/session/process" ".gt/config.sh"
}	# ----------  end of function init  ----------

read_config_on_pwd(){
	config_file=".gt/config.sh"
	[[ -f $config_file ]] && . $config_file && return 0
return 1
}

read_configuration(){
	local pwd
	pwd=$(pwd)
	parent=${pwd}
	while [ ! -z "$parent" ]; do
		[[ -d $parent/.gt ]] && read_config_on_pwd && return 0
		parent=${parent%/*}
		cd $parent
	done
	rerun_log error  "Project has not being initialized. Run init in the home directory before read configuration"
}

last_modified_file(){
	echo $(ls $1 -ltr | tail -1 | head -1 | rev | cut -d " " -f1 | rev)
}

