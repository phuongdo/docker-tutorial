#!/usr/bin/env bash
# check log every 1 minutes?
#file log to monitors
filename=$1
#sleep time in s,m or d. Eg 1s=1 second, 5m=5 minutes, 10d =10 days
timeSleep=$2
#decay time
timeDecay=$3
#service id which is registed in go-monitors tool
serviceId=$4
GO_MONITOR=http://192.168.23.175:9999/log
echo "Press [CTRL+C] to stop.."
while true
do

 found=$(find $filename -cmin -$timeDecay -printf "%f")
    if [ $found ]; then
        echo 'found changes.....'
        content=$(tail -n 1 $filename)
        # post data to monitor service
        curl -silent -H "Accept: application/json" -H "Content-Type: application/json"  -X POST -d "{\"id\":\"$serviceId\",\"level\":0,\"mesg\":\"$content\" }" $GO_MONITOR > /dev/null
    fi
 sleep $timeSleep
done
