
export EM_PROCESS_LOGS=${EM_CORE_HOME}/logs/ad/cre/session/process

. "$RERUN_MODULES"/logs/lib/api.sh 



tad(){
	cd "$EM_CORE_HOME"
}
ccadmin(){
	"$EM_CORE_HOME"/bin/ccadmin.sh $@
}
ad_kill(){
	echo Killing session in appserver: $APP_SERVER
	kill -9 $(ps -ef | grep java |  grep container.name=ad  | awk '{print $2}')
}

as_kill_all(){
	process_ids=$(ps -ef | grep java | grep container.name | awk '{print $2}')

	for process_id in $process_ids; do
		echo Killling $process_id
		kill -9 $process_id
	done

}

ad_restart(){
  ad_kill
	sleep 2s
	ccadmin start-appserver -Dcontainer.name=ad
}

## modules-sql
modules_rev_number(){
	MODULES_REV_NUMBER=$(find "$EM_CORE_HOME"/modules/* -name update.sequence | xargs cat | cut -d " " -f 3 | sort -V | tail -n1)
	echo $MODULES_REV_NUMBER
}

ced_kill(){
	kill -9 $(ps -ef | grep java | grep ../lib/Toolbox.jar | awk '{print $2}')
}

ced_restart(){
	ced_kill
	ccadmin ced
}

show_config(){
	ccadmin show-config
	gnome-open "$EM_CORE_HOME/work/config/show-config-html/index.html"
}
