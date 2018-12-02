#!/bin/bash 

trap shutdown INT SIGTERM

d_red=$'\033[0;31m'
d_cyan=$'\033[0;36m'
d_nc=$'\033[0m'
d_green=$'\033[0;32m'

shutdown() {

	if [ "$1" != 0 ] ; then 
		printf -- "\nExit $1: $2\n"
		
	fi
	printf -- "${d_green}Thank you for using devops tools\n"
	printf -- "Copyright (c) Zubcevic.com 2018${d_nc}\n"
	exit $1

}

time_out() {
	sleep $1
	kill -TERM $2
}

getSoapAction() {
echo "-H SOAPAction: $1"
}

d_headersonly="-I "
d_followredirects="-L "


getContentType() {
case "$1" in 
	"soap11")
		echo "Content-Type: text/xml"
	;;
	"soap12")
		echo "Content-Type: application/soap+xml; action=$2;charset=UTF-8"
	;;
	*)
		echo "Content-Type: application/json"
	;;
esac
}

# Generic function to generate or call curl commands
# For testing JSON/SOAP or any other HTTP request
# -s silent -L follow redirects -4 IPv4 -I only headers
getCurlCommand() {
d_content_type=$(getContentType $3)
#d_cmd="-w \"%{http_code}\" -s -o .tmpout "
if [ "$2" != "GET" ];then
d_cmd="-X $2"
fi
d_cmd="$d_cmd -H \"Connection: Keep-Alive\" "
d_cmd="$d_cmd -H \"User-Agent: Bash\" "
d_cmd="$d_cmd -H \"$d_content_type\" $1 "

}



