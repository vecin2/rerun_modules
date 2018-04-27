# Generated by stubbs:add-option. Do not edit, if using stubbs.
# Created: Mon  5 Mar 21:03:09 GMT 2018
#
#/ usage: logs:init [ --machine_name|-mn <>] [ --container_name <>] [ --process] 

# _rerun_options_parse_ - Parse the command arguments and set option variables.
#
#     rerun_options_parse "$@"
#
# Arguments:
#
# * the command options and their arguments
#
# Notes:
#
# * Sets shell variables for any parsed options.
# * The "-?" help argument prints command usage and will exit 2.
# * Return 0 for successful option parse.
#
rerun_options_parse() {
  
    unrecognized_args=()

    while (( "$#" > 0 ))
    do
        OPT="$1"
        case "$OPT" in
            --machine_name|-mn) rerun_option_check $# $1; MACHINE_NAME=$2 ; shift 2 ;;
            --container_name) rerun_option_check $# $1; CONTAINER_NAME=$2 ; shift 2 ;;
            --process) PROCESS=true; [[ ${2:-} == 'true' ]] && shift ; shift ;;
            # help option
            -\?|--help)
                rerun_option_usage
                exit 2
                ;;
            # unrecognized arguments
            *)
              unrecognized_args+=("$OPT")
              shift
              ;;
        esac
    done

    # Set defaultable options.

    # Check required options are set

    # If option variables are declared exportable, export them.

    # Make unrecognized command line options available in $_CMD_LINE
    if [ ${#unrecognized_args[@]} -gt 0 ]; then
      export _CMD_LINE="${unrecognized_args[@]}"
    fi
    #
    return 0
}


# If not already set, initialize the options variables to null.
: ${MACHINE_NAME:=}
: ${CONTAINER_NAME:=}
: ${PROCESS:=}
# Default command line to null if not set
: ${_CMD_LINE:=}


