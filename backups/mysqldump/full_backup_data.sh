#!/bin/bash -
#Description: create full bakcups with mysqldump
#Author:      karony
#Data:        2017-06-27
#

backup_dir=/data/backups
db_user=root
db_passwd=root
db_host=localhost

[[ ! -d $backup_dir ]] && mkdir -p $backup_dir > /dev/null

mysqldump --user=$db_user --password=$db_passwd --host=$db_host --all-databases --flush-log --master-data=2 \
--single-transaction -E --trigger -R > $backup_dir/mysql.$(date +%F)

find $backup_dir -mtime +5 -exec rm -rf {} \;
