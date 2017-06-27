#!/bin/bash -
#Description: create full bakcups with mysqldump
#Author:      karony
#Data:        2017-06-27
#
[[ ! -d /data/backups ]] && mkdir -p /data/backups/ > /dev/null
mysqldump --user=root --password=root --host=localhost --all-databases --flush-log --master-data=2 --single-transaction -E --trigger -R > /data/backups/mysql.$(date +%F)
