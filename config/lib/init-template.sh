
export EM_PROCESS_LOGS=${EM_CORE_HOME}/logs/ad/cre/session/process

tad(){
	cd "$EM_CORE_HOME"
}
ccadmin(){
	"$EM_CORE_HOME"/bin/ccadmin.sh $@
}
