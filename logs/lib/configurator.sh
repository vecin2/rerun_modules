#!/bin/bash

config_path=".gt/config.sh"

rerun_args_error ()
{
	rerun_color red  "wrong #args, invocation should be '${FUNCNAME[1]} "$@"'\n"
	return 1
}

find_file_on_ancesters() { 
	dir_name=$1
	file_name=$2
	full_path=$1/$2
	if [ -f "$full_path" ]; then 
		echo "$full_path"
	elif [ -z "$dir_name" ]; then 
		return 1
	else 
	 	dir_name=${dir_name%/*}
		find_file_on_ancesters "$dir_name" "$file_name"
	fi
} 

find_in_parent(){
	echo $(find_file_on_ancesters "$(pwd)" "$1")
}

path_to_config(){
	echo $(find_in_parent "$config_path")
}

add_config_variable () { 
	if [ "$#" != "2" ]; then
		rerun_args_error "name" "value" 
		return 2
	fi
	local var_name=$1 var_value=$2 
	echo "$var_name=$var_value" >> $config_path
}	# ----------  end of function add_config_variable  ----------

init_config(){
	  AD=$(pwd)
		config_parent_folder=$1
		mkdir -p `dirname $config_parent_folder/$config_path`
	  touch "$config_path"
		add_config_variable "PROCESS_LOGS" "$AD/logs/${MACHINE_NAME}-${CONTAINER_NAME}/cre/session/process"
		add_config_variable "APP_LOGS" "$AD/logs/${MACHINE_NAME}-${CONTAINER_NAME}/cre/session/application"
		add_config_variable "SERVER_LOGS" "$AD/logs/${MACHINE_NAME}-${CONTAINER_NAME}/weblogic"
}

read_property_value(){
	local file property property_line result
	file=$1 property=$2
	property_line=$(grep "$property" $file)
	result=${property_line##*=}
	#remove windows return carriage character
	echo $result|tr -d '\r'
}

read_ccadmin_properties(){
	local ccadmin_properties_file
	ccadmin_properties_file=$(find_in_parent "config/ccadmin.properties")
	if [ ! -f $ccadmin_properties_file ]; then
		return 1
	fi
	if [[ -z ${MACHINE_NAME:=} ]]; then
		MACHINE_NAME=$(read_property_value $ccadmin_properties_file \
			"ccadmin.machine.name")
	fi
	if [[ -z ${CONTAINER_NAME:=} ]]; then
		CONTAINER_NAME=$(read_property_value $ccadmin_properties_file \
			"ccadmin.container.name")
	fi
}
var_name(){
	local line="$1"
	local var_name="${line%%=*}"
	echo ${var_name##* }
}

formated_var_name(){
	local line="$1"
	local var_name=$(var_name "$line")
	log_name=$(echo "${var_name/_/ }" | awk '{print tolower($0)}' \
							| sed -r 's/(^| )([a-z])/ \U\2/g')
	echo "$log_name"
}

var_value(){
	line="$1"
	var_name=$(var_name "$line")
	echo "${!var_name}"
}
