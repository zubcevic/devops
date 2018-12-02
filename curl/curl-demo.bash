#!/bin/bash 

. ./curl-lib.bash

#time_out 120 "$$" &


d_opts="-s -o .tmpout --http1.1 "
getCurlCommand https://httpbin.org/get?test=this+is+a+test GET json

dryRun() {
	echo "curl $d_cmd"
}

runCommand() {
	rm .tmpout > /dev/null 2>&1
	eval "curl $d_opts $d_cmd > /dev/null"
	cat .tmpout | sed "s/,/\n/g"  | grep 'test' |head -n 1| sed "s/:/ /g" |awk -F\" '{print $4}' 
}

######################################
# Menu                               #
######################################
dep_options=("dryrun" "run" "quit")
select dep_option in "${dep_options[@]}"
do
	case $dep_option in
		"dryrun")
			dryRun
			;;
		"run")
			runCommand
			;;
		*)
			shutdown
			;;
	esac
done




