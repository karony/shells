#!/bin/bash
# Description: install docker in CentOS
# Date: 2019-05-17
# Author: lirou
# Version: 1.0.0

if [ $# -eq 0 ];then
  echo 'ERROR: usage $(basename $0) DOCKER_REPO_MIRROR'
  exit 3
fi

REPO_URL=https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
WGET_BIN=`which wget`

DOCKER_REPO_MIRROR=$1
DOCKER_ROOT_DIR=

# configure docker repo
if [[ "X$WGWT_BIN" == "X" ]]; then
	echo -n 'Install wget \n'
	yum -y install wget
	if [ $? -ne 0 ];then
		echo "Can't install wget"
		exit 2
	fi
fi

wget $REPO_URL -P /etc/yum.repos.d

# install docker-ce
yum clean all
yum -y install docker-ce

# set configure file
if ! [ -d /etc/docker ];then
	mkdir /etc/docker
fi

cat <<EOF >/etc/docker/daemon.json
{ "registry-mirrors":["$DOCKER_REPO_MIRROR"] }
EOF

# start docker service
systemctl enable docker
systemctl start docker

# docker status
if systemctl status docker | grep -q -i 'running' ;then
	echo "docker is running"
else
	echo "docker can't start"
fi
