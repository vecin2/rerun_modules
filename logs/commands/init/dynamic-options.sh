#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
module_home_dir=$dir/../..

. $module_home_dir/lib/configurator.sh

config_file=$(path_to_config)
for line in `grep LOGS $config_file`; do
	echo ${line%%_*} | awk '{print tolower($0)}'
done


