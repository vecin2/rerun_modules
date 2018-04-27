# 
# Test functions for command tests.
#
templates_dir(){
	echo $RERUN_MODULES/logs/lib/templates
}

build_logs(){
	cp -r $(templates_dir)/logs $1
}

build_config ()
{
	local source_folder=$1
	local config_source="$source_folder/.gt"
	local config_file=$config_source/config.sh
	mkdir -p $config_source

	cp $(templates_dir)/config.sh  $config_source
	sed -i "s|CORE_HOME=.*|CORE_HOME=$project_path|" $config_file
	echo "$config_file"
}	# ----------  end of function build_config  ----------

build_local_ccadmin_properties(){
	mkdir -p config
	cp -r $(templates_dir)/ccadmin.properties config/
}

recreate_project_setup(){
	project_name=$1
	project_path=$(pwd)/$project_name

	rm -r $project_name || true
	mkdir $project_name

	build_config "$project_path"
	build_logs "$project_path"
	cd $project_path
	echo $project_path
}

recreate_local_project_setup(){
	recreate_project_setup "$@"
	build_local_ccadmin_properties
}

assert_prints_error ()
{
	(( $# < 2 )) && {
		printf >&2 'wrong # args: should be: \
			          assert_print_error function_to_invoke expected message\n'
	}
	local invocation=$1 expected_message=$2 \
      	red="\\\033\[31m" reset="\\\033\[0m"

	output=$($invocation 2>&1)
	output=$(echo "$output" 	| grep "echo -ne" \
	         | sed -e "s,.*$red\(.*\)$reset.*,\1,")

	test -n "$output" -a "$output" = "$expected_message"
	###Other solution using string manipulation
		#red=$(rerun_color_code red)
		#reset=$(rerun_color_code reset)
		#output=${output##*$red}
		#output=${output%%$reset*}
}	# ----------  end of function assert_prints_error  ----------

# - - -
# Your functions declared here.
# - - -


