_ccadmin() 
{
	local cur 
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[$COMP_CWORD-1]}"
	before_prev="${COMP_WORDS[$COMP_CWORD-2]}"


	if [ -z "$CCADMIN_COMPLETION_OPTS" ]; then
		CCADMIN_COMPLETION_OPTS=$(cat "$EM_CORE_HOME"/.em/autocompletion/ccadmin_completion)
		export CCADMIN_COMPLETION_OPTS
	fi

	if [ "${prev}" == "ccadmin" ] || [ "${before_prev}" == "ccadmin" ] ; then
		COMPREPLY=( $(compgen -W "${CCADMIN_COMPLETION_OPTS}" -- ${cur}) )
		return 0
	fi
}
complete -o default -F _ccadmin ccadmin
