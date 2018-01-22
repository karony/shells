#!/bin/bash

#script name:rsync_yumrepo.sh

RsyncBin="/usr/bin/rsync"
RsyncPerm='-avrt --delete --no-iconv --bwlimit=40000'
Centos_7_base='/data/yumpack/centos/7/os/'
Centos_7_epel='/data/yumpack/epel/7/'
Centos_7_zabbix='/data/yumpack/zabbix/3.0/centos/7/'
Centos_7_extras='/data/yumpack/centos/7/extras/'
Centos_7_updates='/data/yumpack/centos/7/updates/'
Centos_6_base='/data/yumpack/centos/6/os/'
Centos_6_epel='/data/yumpack/epel/6/'
Centos_6_zabbix='/data/yumpack/zabbix/3.0/centos/6/'
Centos_6_extras='/data/yumpack/centos/6/extras/'
Centos_6_updates='/data/yumpack/centos/6/updates/'
LogFile='/data/yumpack/rsync_yum_log'
Date=`date +%Y-%m-%d`

function check {
    if [ $? -eq 0 ];then
        echo -e "\033[1;32mRsync is success!\033[0m" >>$LogFile/$Date.log
    else
        echo -e "\033[1;31mRsync is fail!\033[0m" >>$LogFile/$Date.log
    fi
}

if [ ! -d "$Centos_7_base" ];then
    mkdir -pv $Centos_7_base
fi

if [ ! -d "$Centos_7_epel" ];then
    mkdir -pv $Centos_7_epel
fi
if [ ! -d "$Centos_7_zabbix" ];then
    mkdir -pv $Centos_7_zabbix
fi

if [ ! -d "$Centos_7_extras" ];then
    mkdir -pv  $Centos_7_extras
fi

if [ ! -d "$Centos_7_updates" ];then
    mkdir -pv  $Centos_7_updates
fi

if [ ! -d "$Centos_6_base" ];then
    mkdir -pv $Centos_6_base
fi

if [ ! -d "$Centos_6_epel" ];then
    mkdir -pv $Centos_6_epel
fi
if [ ! -d "$Centos_6_zabbix" ];then
    mkdir -pv $Centos_6_zabbix
fi

if [ ! -d "$Centos_6_extras" ];then
    mkdir -pv  $Centos_6_extras
fi

if [ ! -d "$Centos_6_updates" ];then
    mkdir -pv  $Centos_6_updates
fi

if [ ! -d "$LogFile" ];then
    mkdir $LogFile
fi

#rsync centos 6 base
echo 'Now start to rsync centos 6 base!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm  rsync://mirrors.tuna.tsinghua.edu.cn/centos/6/os/x86_64 $Centos_6_base >>$LogFile/$Date.log
check

#rsync centos 6 epel
echo 'Now start to rsync centos 6 epel!' >>$LogFile/$Date.log
$RsyncBin  $RsyncPerm  rsync://mirrors.tuna.tsinghua.edu.cn/epel/6/x86_64 $Centos_6_epel  >>$LogFile/$Date.log
check

#rsync centos 6 extras
echo 'Now start to rsync centos 6  extras!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/centos/6/extras/x86_64 $Centos_6_extras >>$LogFile/$Date.log
check

#rsync centos 6 updates
echo 'Now start to rsync centos 6  updates!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/centos/6/updates/x86_64 $Centos_6_updates >>$LogFile/$Date.log
check

#rsync centos 6 zabbix
echo 'Now start to rsync centos 6  zabbix!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.0/rhel/6/x86_64/ $Centos_6_zabbix >>$LogFile/$Date.log
check


#rsync centos 7 base
echo 'Now start to rsync centos 7 base!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64 $Centos_7_base >>$LogFile/$Date.log
check

#rsync centos 7 epel
echo 'Now start to rsync centos 7 epel!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/epel/7/x86_64 $Centos_7_epel >>$LogFile/$Date.log
check

#rsync centos 7 extras
echo 'Now start to rsync centos 7 extras!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/extras/x86_64 $Centos_7_extras >>$LogFile/$Date.log
check

#rsync centos 7 updates
echo 'Now start to rsync centos 7  updates!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/centos/7/updates/x86_64 $Centos_7_updates >>$LogFile/$Date.log
check

#rsync centos 7 zabbix
echo 'Now start to rsync centos 7  zabbix!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm rsync://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.0/rhel/7/x86_64/ $Centos_7_updates >>$LogFile/$Date.log
check
