# 
# Test functions for command tests.
#

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


