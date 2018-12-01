#!/bin/bash 

. ./curl-lib.bash

d_opts="-s -o .tmpout --http1.1 "
getCurlCommand https://httpbin.org/get?test=this+is+a+test GET json

if [ "$1" == "dryrun" ];
then
	echo "curl $d_cmd"
else
	rm .tmpout > /dev/null 2>&1
	eval "curl $d_opts $d_cmd > /dev/null"
	cat .tmpout | sed "s/,/\n/g"  | grep 'test' |head -n 1| sed "s/:/ /g" |awk -F\" '{print $4}' 
fi
#| sed "s/\"//g"

#sed "s/.* bla=\"\(.*\)\".*/\1/" | sed 's#.*/##' | sed 's/".*//'





