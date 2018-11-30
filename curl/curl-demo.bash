#!/bin/bash 

trap shutdown INT SIGTERM

shutdown() {

	if [ "$1" != 0 ] ; then 
		printf -- "\nExit $1: $2\n"
		
	fi
	printf -- "Thank you for using devops tools\n"
	printf -- "Copyright (c) Zubcevic.com 2018\n"
	exit $1

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

d_opts="-s -o .tmpout --http1.1 "
getCurlCommand https://httpbin.org/get?test=this+is+a+test GET json

if [ "$1" == "dryrun" ];
then
	alias curl
	echo "curl $d_cmd"
else
	rm .tmpout > /dev/null 2>&1
	eval "curl $d_opts $d_cmd > /dev/null"
	cat .tmpout | sed "s/,/\n/g"  | grep 'test' |head -n 1| sed "s/:/ /g" |awk -F\" '{print $4}' 
fi
#| sed "s/\"//g"

#sed "s/.* bla=\"\(.*\)\".*/\1/" | sed 's#.*/##' | sed 's/".*//'





