#!/bin/bash

source defs.sh

#Execute speedtest 
# Extract Download and Upload values from file testspeed.out and store  in bash vars (Download, Upload)
eval $(python -u tespeed.py -w -s | awk 'BEGIN {FS = ","} ; {print "Download="$1; print "Upload="$2}' )
#echo $Download
#echo $Upload

modem_out=$(wget -qO- --user=$MODEM_USER --password=$MODEM_PASS $MODEM_ADDR$MODEM_DSL_PAGE)

for idx in $ARR_IDXS
do
    eval $(echo "$modem_out" | grep "${ARR_MODEM_STRING[$idx]}"  | python extract_html_data.py "VALUE_FROM_HTML[$idx]")
done

VALUE_FROM_HTML[0]=$Download
VALUE_FROM_HTML[1]=$Upload


#DEBUG
#for idx in $ARR_IDXS
#do
#    echo ${ARR_GRAPH_TITLE[idx]}"-->"${VALUE_FROM_HTML[$idx]}
#done

#Monta a string que serah usada para atualizar o rrdtool
str_exec="rrdtool update $DATABASE N"
for idx in `seq 0 $ARR_LAST_IDX`
do
    #Concatenate values to string
    str_exec="$str_exec:${VALUE_FROM_HTML[idx]}"
done

#Exec rrdtool update
$str_exec
##rrdtool update $DATABASE N:$Download:$Upload:$DownCurrRate:$UpCurrRate:$DownMaxRate:$UpMaxRate:$DownNoiseMargin:$UpNoiseMargin:$DownAtt:$UpAtt:$DownPower:$UpPower:$DownFEC:$UpFEC
