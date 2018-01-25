#!/bin/bash
# Description: innobackupex backup MySQL
# Date: 2018-01-23
# Version: 0.1.1
# Author: karony
# Node: you must make sure this script will excute when you make cron 
# 	monday is full bakcup, other days is incremetal backup.

### backup vars
backup_dir_parent=/var/lib/mysql/backups
backup_dir=
full_backup_dir=
increment_backup_dir=
backup_times=
backup_max_times=5

### MySQL vars
mysql_host=127.0.0.1
mysql_user=root
mysql_password=root
defaults_file=/etc/my.cnf

# record backup log
backup_log=/var/log/innobackup/innobackup.log
# record a full backup or increamental backup whether or not success.
backup_status=/var/log/innobackup/innobackup.status

! [ -d $backup_dir_parent ] && mkdir -pv $backup_dir_parent &> /dev/null
! [ -d $(dirname $backup_log) ] && mkdir -pv $(dirname $backup_log) &> /dev/null

week=$(date "+%u")

if [ $week -eq 1 ]; then


	backup_dir=${backup_dir_parent}/backup-$(date "+%Y-%m-%d")
	full_backup_dir=${backup_dir}/full
	innobackupex --defaults-file=${defaults_file} --host=${mysql_host} --user=${mysql_user} --password=${mysql_password} ${full_backup_dir} &> $backup_log
	echo "$(date '+%Y-%m-%d-%H-%m-%S'):$?" >>  $backup_status	

	backup_times=$(ls -l $backup_dir_parent | grep -i '^d.*backup.*' | wc -l)	
	if [ $backup_times -ge $backup_max_times ];then
		rm -rf ${backup_dir_parent}/$(ls -lt $backup_dir_parent |tail -l)
	fi
else
	backup_dir=${backup_dir_parent}/$(ls  -lt $backup_dir_parent | grep -i '^d.*backup.*' | head -1 | grep -o 'backup.*')
	increment_backup_dir=${backup_dir}/incr-${week}
	echo innobackupex --defaults-file=${defaults_file} --host=${mysql_host} --user=${mysql_user} --password=${mysql_password} --incremental-basedir=${backup_dir}/full/$(ls ${backup_dir}/full | head -1) --incremental ${increment_backup_dir} 
	echo "$(date '+%Y-%m-%d-%H-%m-%S'):$?" >>  $backup_status	
fi
