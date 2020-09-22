#!/bin/bash

basicauth="username:password"      
page_id=1
#page_info = curl -u ${basicauth} 'https://www.zubcevic.com/rest/api/content/'${page_id}'?expand=version' 
page_info='{"type":"type","title":"title","version":{"number":1}}'
page_version=$(echo $page_info | sed 's/,/ /g'|grep number )
echo $page_version

page_version=1
page_version=$((page_version+1))
echo $page_version
                    
#echo '{"id":"'${page_id}'","type":"page","title":"test","space":{"key":"spacekey"},"body":{"storage":{"value":"'$TEXT'","representation":"storage"}},"version":{"number":'$page_version'}}' > update.json
#curl -u ${basicauth} -X PUT -H 'Content-Type: application/json' -d '@update.json' https://www.zubcevic.com/rest/api/content/${page_id} 
rm update.json
