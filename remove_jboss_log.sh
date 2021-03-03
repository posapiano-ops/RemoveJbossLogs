#!/bin/bash
# Author: Raffaele Fiorito
# rfiorito@outlook.it
# path /opt/OpenIAM/jboss/jboss-as-7.1.1.Final/standalone/log/server.log

LSOF=$(which lsof)
FIND=$(which find)
CAT=$(which cat)
TRUNCATE=$(which truncate)
LOG_FILE="server.log"

#Esempio crontab
# 00 1 * * $HOME/bin/remove_log.sh $HOME/bin/remove_log_path 30 >> /dev/null

if [ $# -eq 1 ] || [ $# -eq 2 ]; then
if [ ! -f $LSOF ]; then
        echo "Program lsof not installed"
        exit 1
fi
CONFIG_FILE=$1
RETENTION=$2
DATE=`date +%F"-"%H%M`
COMPRESS="gzip -9"

REMOVE() {
echo $FIND $1 -type f -mtime +$RETENTION -exec rm {} \;
}


#for path in `cat $CONFIG_FILE |grep -v "^#"`
for path in $CONFIG_FILE
do

if [ -f $path ]; then
        $LSOF $path
        ACTIVE=$?
        if [ $ACTIVE != 0 ]; then
        $COMPRESS -9 $path
        fi
elif [ -d $path ]; then
        for file in `ls -l $path |grep "^-" | awk '{print $NF}' | grep -v -E '*.gz|*.Z'`
        do
                $LSOF $path/$file >/dev/null 2>&1
                ACTIVE=$?
                if [ $ACTIVE != 0 ]; then
                        $COMPRESS $path/$file
                elif [ $file == $LOG_FILE ] ; then
                $CAT $path/$file | $COMPRESS > $path/$file.$DATE.gz
                $TRUNCATE -s 0  $path/$file
                fi
        done
fi
done
REMOVE $path
else
echo "Usage $0 {Conf File Path} {retention}"
fi
