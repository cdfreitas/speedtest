#!/bin/bash

source defs.sh

echo "Content-type: text/html"
echo ""
echo "<html><head><title>CGI"
echo "</title></head><body>"


for idx in $ARR_IDXS
do
   filename="${ARR_GRAPH_FILENAME[$idx]}_$QUERY_STRING.png"
   rrdtool graph $filename --start -1$QUERY_STRING --slope-mode --title="${ARR_GRAPH_TITLE[$idx]}" --vertical-label=${ARR_GRAPH_VERTICAL_LABEL[$idx]} -z \
   DEF:a=$DATABASE:${ARR_DATABASE_DS_NAME[$idx]}:AVERAGE \
   LINE:a#FF0000 > /dev/null

   echo "<img src=$filename>"
   echo "<br>"
done

echo "<br>"
echo "<center>Information generated on $(date)</center>"
echo "<br><br><br><br><br><br><br>"
echo "</body></html>"

