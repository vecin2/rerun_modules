# Shell functions for the config module.
#/ usage: source RERUN_MODULE_DIR/lib/functions.sh command
#

# Read rerun's public functions
. "$RERUN" || {
    echo >&2 "ERROR: Failed sourcing rerun function library: \"$RERUN\""
    return 1
}

# Check usage. Argument should be command name.
[[ $# = 1 ]] || rerun_option_usage

# Source the option parser script.
#
if [[ -r "$RERUN_MODULE_DIR/commands/$1/options.sh" ]] 
then
    . "$RERUN_MODULE_DIR/commands/$1/options.sh" || {
        rerun_die "Failed loading options parser."
    }
fi

# - - -
# Your functions declared here.
# - - -

create_config_file ()
{
	if [ ! -z "${1:-}" ]; then
		config_path="$1"
	else
		config_path="${HOME}/.em.bash"
	fi
	source_dir="$RERUN_MODULES"/config/lib
	
	template_path="$source_dir"/init-template.sh
	cp  "$template_path" "$config_path"

	#prepend core_home = current directory
	EM_CORE_HOME=$(pwd)
	sed -i "1iexport EM_CORE_HOME=$EM_CORE_HOME" "$config_path"

	echo "$config_path"
}	# ----------  end of function create_config_file  ----------


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#. $DIR/configurator.sh

# - - -
# Your functions declared here.
# - - -

add_config_variable () { 
	if [ "$#" != "3" ]; then
		rerun_args_error "name" "value" "file"
		return 2
	fi
	local var_name=$1 var_value=$2 file=$3
	echo "$var_name=$var_value" >> $file
}	# ----------  end of function add_config_variable  ----------

read_property_value(){
	if [ "$#" != "2" ]; then
		rerun_args_error "file" "property_name" 
	fi
	local file property property_line result
	file=$1 property=$2
	property_line=$(grep "$property" $file)
	result=${property_line##*=}
	#remove windows return carriage character
	echo $result|tr -d '\r'
}

init_ccadmin_properties(){
	local ccadmin_properties_file
	ccadmin_properties_file=$AD/config/ccadmin.properties
	if [[ -z $MACHINE_NAME ]]; then
		MACHINE_NAME=$(read_property_value $ccadmin_properties_file \
			"ccadmin.machine.name")
	fi
	if [[ -z $CONTAINER_NAME ]]; then
		CONTAINER_NAME=$(read_property_value $ccadmin_properties_file \
			"ccadmin.container.name")
	fi
}

init () {
	if [ -f ".gt/config.sh" ]; then
		rm ".gt/config.sh";
	fi
	AD=$(pwd)
	if [[ ! -f "$AD/config/ccadmin.properties" && -z ${MACHINE_NAME:=} ]]; then
		local error="Please pass ccadmin properties or create config/ccadmin.properties"
		rerun_log error $error
		return 1
	else
		mkdir -p .gt
		init_ccadmin_properties
		add_config_variable "PROCESS_LOGS" "$AD/logs/${MACHINE_NAME}-${CONTAINER_NAME}/cre/session/process" ".gt/config.sh"
		add_config_variable "APP_LOGS" "$AD/logs/${MACHINE_NAME}-${CONTAINER_NAME}/cre/session/application" ".gt/config.sh"
		add_config_variable "SERVER_LOGS" "$AD/logs/${MACHINE_NAME}-${CONTAINER_NAME}/weblogic" ".gt/config.sh"
		rerun_color blue "Project initialised, showing \".gt/config.sh\" content:\n"
		cat ".gt/config.sh" 
	fi
}	# ----------  end of function init  ----------

read_configuration(){
	path=$(path_to_config)
	if [ -z $path ]; then
		rerun_log error  "Project has not being initialized. Run init in the home directory before read configuration"
		return 1
	fi
	. $path
}

last_modified_file(){
	echo $(ls $1 -ltr | tail -1 | head -1 | rev | cut -d " " -f1 | rev)
}

