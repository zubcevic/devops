#!/bin/bash 

trap shutdown INT SIGTERM

shutdown() {

	if [ "$1" != 0 ] ; then 
		printf -- "\nExit $1: $2\n"
		
	fi
	printf -- "Thank you for using devops tools\n"
	printf -- "Copyright (c) Zubcevic.com 2017\n"
	exit $1

}

if [ "$1" == "dryrun" ];then
d_dryrun="Y"
fi

getSoapAction() {
echo "-H SOAPAction: $1"
}

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
local d_content_type=$(getContentType $3)
local d_cmd="-f -I -L -4 -w \"%{http_code}\" -s -o /dev/null "
if [ "$2" != "GET" ];then
local d_cmd="-X $2"
fi
local d_cmd="$d_cmd -H \"Connection: Keep-Alive\" "
local d_cmd="$d_cmd -H \"User-Agent: Bash\" "
local d_cmd="$d_cmd -H \"$d_content_type\" $1 "

echo "$d_cmd"

}

checkHomePageCommand=$(getCurlCommand http://www.github.com GET json)

if [ "$d_dryrun" == "Y" ];then
d_ret=$(echo curl $checkHomePageCommand)
else 
d_ret=$(curl $checkHomePageCommand 2>/dev/null)
fi

echo "$d_ret"
if [ "$d_ret" == "200" ];then
printf "Site is up!\n"
fi

