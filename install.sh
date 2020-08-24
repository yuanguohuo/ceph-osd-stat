#!/bin/bash

myname=yuanguo.huo
myhome=/home/$myname
CRONT="crontab -u $myname"

#install perl File-Tail
tar zxvf File-Tail-0.99.3.tar.gz
cd File-Tail-0.99.3
perl Makefile.PL 
make
make install
cd -

mkdir -p $myhome
mkdir -p $myhome/osdstat

cp  OsdStat.pm       \
    TrackedOp.pm     \
    TrackerEvent.pm  \
    osd-stat.pl      \
    osdstat_watch.sh \
    $myhome


$CRONT -l > crontab.bak  
sed -i -e '/osdstat_watch/d' crontab.bak
sed -i -e '/osd-stat/d' crontab.bak
echo "*/1 * * * * bash /home/yuanguo.huo/osdstat_watch.sh > /dev/null 2>&1"  >> crontab.bak
#restart it every day (killed and started up by watch)
echo "0 0 * * *   ps -ef | grep osd-stat.pl | grep -v grep | tr -s ' ' | cut -d ' ' -f 2 | xargs kill -9" >> crontab.bak
$CRONT crontab.bak
