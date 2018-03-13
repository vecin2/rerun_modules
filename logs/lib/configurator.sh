#!/bin/bash
config_path=".gt/config.sh"
rerun_args_error ()
{
	echo ******************************************************************************************************
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

path_to_config(){
	echo $(find_file_on_ancesters "$(pwd)" "$config_path")
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



