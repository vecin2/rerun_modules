# Shell functions for the sql module.
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
list_sql_templates(){
	menu=( $1/* )
	i=1
	for m in ${menu[@]}
	do
		echo  "$(( i++ ))) $(basename ${m%.*})"
	done |xargs -L3 |column -t
}


