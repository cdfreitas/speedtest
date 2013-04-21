#!/bin/bash
# 
# update_database.sh
# Updates the rrd (rrdtool)  database
#
# 201301 - Christian D Freitas

# Import definitions
source defs.sh


# Executes tespeed - measures Download and Upload speed 
eval $(python -u tespeed.py -w -s | awk 'BEGIN {FS = ","} ; {print "Download="$1; print "Upload="$2}' )

# Gets html file (statistics) from the modem
modem_out=$(wget -qO- --user=$MODEM_USER --password=$MODEM_PASS $MODEM_ADDR$MODEM_DSL_PAGE)

# Extracts values from the wget output (stored in modem_out) 
# The python code outputs an assignment VALUE_FROM_HTML[idx]=value that is evaluated by eval
for idx in `seq 0 $ARR_LAST_IDX`
do
    eval $(echo "$modem_out" | grep "${ARR_MODEM_STRING[$idx]}"  | python extract_html_data.py "VALUE_FROM_HTML[$idx]")
done

# Stores the values measured by tespeed in the VALUE_FROM_HTML array (TODO: change this variable name)
VALUE_FROM_HTML[0]=$Download
VALUE_FROM_HTML[1]=$Upload


#DEBUG
#for idx in $ARR_IDXS
#do
#    echo ${ARR_GRAPH_TITLE[idx]}"-->"${VALUE_FROM_HTML[$idx]}
#done

# Builds the command that will be used to update the rrdtool database
str_exec="rrdtool update $DATABASE N"
for idx in `seq 0 $ARR_LAST_IDX`
do
    #Concatenates values to the string
    str_exec="$str_exec:${VALUE_FROM_HTML[idx]}"
done

#Exec rrdtool update
$str_exec
