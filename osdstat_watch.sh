#!/bin/bash

osdstat_watch_version="version: 20160120 0101"
osdstat_dir=`echo ~`
osdstat="$osdstat_dir/osd-stat.pl"

function version()
{
    echo "$osdstat_watch_version"
    exit
}

while getopts "v" opt
do
    case $opt in
        v)
            version
        ;;
    esac
done

osdstat_status=`ps -ef | grep "$osdstat" | grep -v grep | wc -l`
if [ "$osdstat_status" -gt "0" ]; then
    exit
fi

$osdstat & > /dev/null 2>&1
