_gt() 
{
	local cur 
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[$COMP_CWORD-1]}"
	commands_path=$AD/shell_tools/commands/*
	#commands=$(for file in $commands_path/*; do echo $(${file##*/}); done)
	commands=$(for file in $commands_path; do a=${file##*/}; echo ${a%.*}; done)

#	if [[ ${prev} == gt ]]; then
#		COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
#		return 0
#	fi
case "${prev}" in
	gt)
		COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
		return 0
		;;
	create-unit-test)
    cd $AD/repository/default/
		return 0
		;;
		

esac
}
complete -o default -F _gt gt
