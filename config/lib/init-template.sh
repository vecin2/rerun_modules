
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
	ccadmin stop-appserver -Dcontainer.name=authentication-service
	sleep 2s
	ccadmin start-appserver -Dcontainer.name=ad
	ccadmin start-appserver -Dcontainer.name=authentication-service
}

## modules-sql
modules_rev_number(){
	MODULES_REV_NUMBER=$(find "$EM_CORE_HOME"/modules/* -name update.sequence | xargs cat | cut -d " " -f 3 | sort -V | tail -n1)
	echo $MODULES_REV_NUMBER
}

modules_set_db_rev_no(){
	echo Max rev number in modules:$(modules_rev_number)
	EM_PYTHON_HOME=$HOME/dev/python/em_dev_tools/my_project
	EM_PYTHON="$EM_PYTHON_HOME"/bin/python
	PY_MODULES_HOME=$EM_PYTHON_HOME/repository/modules/

	$EM_PYTHON $PY_MODULES_HOME/database.py $1
}

#ced
ced_kill(){
	process_id=$(ps -ef | grep java | grep ../lib/Toolbox.jar | awk '{print $2}')
	if [ -z "$process_id" ]; then
		echo "ced is not running"
	else
		kill -9 $process_id
	fi
}

ced_restart(){
	ced_kill
	ccadmin ced
}

show_config(){
	ccadmin show-config
	gnome-open "$EM_CORE_HOME/work/config/show-config-html/index.html"
}

#svn
svn_status(){
	REPO_PATH="$EM_CORE_HOME/repository/default/"
	if [ "$#" -ne 1 ]; then
		ST_PATH=.
	else
		ST_PATH=$1
	fi

	echo path is "$ST_PATH"
	svn st "$ST_PATH"
}

svn_del_all(){
	svn_status $1 | grep ^\! | awk '{print $2}' | xargs svn delete  
}
svn_add_all(){
	svn_status $1 | grep ^\? | awk '{print $2}' | xargs svn add
}
