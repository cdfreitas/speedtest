#!/bin/bash
# 
# create_database.sh
# Creates rrd (rrdtool)  database
#
# 201301 - Christian D Freitas

# Import definitions
source defs.sh

# Remove old database
rm $DATABASE

# Database creation 
# rrd
#rrdtool create filename --start time --step secs \
#DS:Label:Type:Heartbeat:Min:Max \
#RRA:Consolidation Function:XFF:Steps:Rows
# sketch  - This database was created to store speedtest results and modem DSL statistcs
# Modem: sagemcom 2764
#rrdtool create $DATABASE \
#         --start now \
#         --step 3600 \
#         DS:Speed_Download:GAUGE:7200:0:U \
#         DS:Speed_Upload:GAUGE:7200:0:U \
#         DS:Mdm_Down_C_Rate:GAUGE:7200:0:U \
#         DS:Mdm_Up_C_Rate:GAUGE:7200:0:U \
#         DS:Mdm_Down_Max_Rate:GAUGE:7200:0:U \
#         DS:Mdm_Up_Max_Rate:GAUGE:7200:0:U \
#         DS:Mdm_Down_Noise_M:GAUGE:7200:0:U \
#         DS:Mdm_Up_Noise_M:GAUGE:7200:0:U \
#         DS:Mdm_Down_Att:GAUGE:7200:0:U \
#         DS:Mdm_Up_Att:GAUGE:7200:0:U \
#         DS:Mdm_Down_Power:GAUGE:7200:0:U \
#         DS:Mdm_Up_Power:GAUGE:7200:0:U \
#         DS:Mdm_Down_FEC:GAUGE:7200:0:U \
#         DS:Mdm_Up_FEC:GAUGE:7200:0:U \
#         RRA:AVERAGE:0.5:1:744 \
#         RRA:AVERAGE:0.5:24:365 
#
# No primeiro RRA acima, serah calculada a media, a cada novo valor (1), e armazenado 744 medias (744 = 24h de  medidas por 31 dias)
# No segundo RRA acima, serah calculada a media, dos ultimos 24 valores, e armazenados 365 medias (ultimos 24 valores = 24h. 24*367 = 1 ano)

# create execution string
str_exec="rrdtool create $DATABASE --start now --step 3600 "

# mount string
for idx in `seq 0 $ARR_LAST_IDX`
do
    str_exec="$str_exec DS:${ARR_DATABASE_DS_NAME[$idx]}:GAUGE:7200:0:U"
done

# append RRAs to the end of string
str_exec="$str_exec RRA:AVERAGE:0.5:1:744 RRA:AVERAGE:0.5:24:365"

# Call string (create database)
$str_exec

