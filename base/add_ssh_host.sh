#!/bin/bash
# Description: add a host name reserve in ssh config
# Date: 2019-05-17
#

CONF_USER=`echo $HOME`
CONF_DIR=$CONF_USER/.ssh
CONF_FILE=$CONF_DIR/config
DOMAIN_NAME=vm.wicc.me

if [ $# -eq 0 ];then
	echo "ERROR: Usage $(basename $0) HOST"
fi
HOST=$1


# init config file

do_init_config() {
	(umask 077; if ! [ -d $CONF_DIR ] ;then  mkdir $CONF_DIR ;fi)
	grep -q -i "$DOMAIN_NAME" $CONF_FILE && return 0
	cat <<EOF >$CONF_DIR/config
host
	HostName %h$DOMAIN_NAME
	Port 9888
EOF
}

add_host() {
	sed -i "s/^\(host.*\)/\1 $HOST/g" $CONF_FILE
}

do_init_config
add_host
