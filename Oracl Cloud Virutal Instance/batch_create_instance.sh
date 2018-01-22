#!/bin/bash
# Description: batch create Oracle Cloud Virtual Instance.
# Date: 2017/11/22
# Author: lirou<lirou@rayvision.com>
# Version: 1.0.1
#

#### set some variables.
Error_Create=2
Error_No_Instance=3
iError_Parameter=4
#node host global variables
oci_path=/root/y/oci
compartment_id=ocid1.tenancy.oc1
tenancy_id=ocid1.tenancy.oc1
subnet_id=ocid1.subnet.oc1.phx
image_id=ocid1.image.oc1.phx
shape="VM.Standard1.1"
#record node host create and delete variables.
file_of_alived_node=/var/lib/oracle/alived.nodes
file_of_ip_number=/var/lib/oracle/ip.txt
file_of_create_node_log=/var/log/oracle/create.log
file_of_delete_node_log=/var/log/oracle/delete.log

### make sure file is existence.
[ ! -d $(dirname $file_of_alived_node) ] && mkdir $(dirname $file_of_alived_node) >>/dev/null
[ ! -d $(dirname $file_of_ip_number) ] && mkdir $(dirname $file_of_ip_number) >>/dev/null
touch $file_of_ip_number
[ ! -d $(dirname $file_of_create_node_log) ] && mkdir $(dirname $file_of_create_node_log) >>/dev/null
[ ! -d $(dirname $file_of_delete_node_log) ] && mkdir $(dirname $file_of_delete_node_log) >>/dev/null

#### create node host
### Usage: Create_Node instance_display_name instance_private_ip volume_display_name volume_size_in_mbs attachment_display_name
function Create_Node {		
	#Create instance
	instance_id=$($oci_path compute instance launch --availability-domain $avail_domain -c $compartment_id --image-id $image_id --shape $shape --display-name $1 --subnet-id $subnet_id --private-ip $2 | grep "\"id\"" | cut -d "\"" -f 4)
	if [[ -z $instance_id ]];then
		echo "[$(date +'%F %T')] [instance] [$1:$2] [create failure] [exit...]" >> $file_of_create_node_log
		exit $ERROR_Create
	else
		echo "[$(date +'%F %T')] [instance] [$1:$instance_id:$2] [create success]" >> $file_of_create_node_log
	fi
	# Create Volume
	volume_id=$($oci_path bv volume create --availability-domain $avail_domain -c $compartment_id --display-name $3 --size-in-mbs $4  | grep "\"id\"" | cut -d "\"" -f 4)
	if [[ -z $volume_id ]];then
		echo "[$(date +'%F %T')] [volume] [$3] [create failure] [exit...]" >> $file_of_create_node_log
		exit $ERROR_Create
	else
		echo "[$(date +'%F %T')] [volume] [$3:$volume_id:$4] [create success]" >> $file_of_create_node_log
	fi
	# Attach Volume to Instance
	while true;do
		instance_state=$($oci_path compute instance get --instance-id $instance_id | grep "lifecycle-state" |cut -d "\"" -f 4)
		volume_state=$($oci_path bv volume get --volume-id $volume_id | grep "lifecycle-state" |cut -d "\"" -f 4)
		if [[ $instance_state == "RUNNING" ]] && [[ $volume_state == "AVAILABLE" ]];then
			volume_attached_id=$($oci_path compute volume-attachment attach --display-name $5 --instance-id $instance_id --type iscsi --volume-id $volume_id | grep "\"id\"" | cut -d "\"" -f 4) 
			if [[ -z $volume_attached_id ]];then
				echo "[$(date +'%F %T')] [volume_attached] [$5] [create failure] [exit...]" >> $file_of_create_node_log
				exit $ERROR_Create
			else
				echo "[$(date +'%F %T')] [volume_attached] [$5:$volume_attached_id] [create success]" >> $file_of_create_node_log
			fi
			break
		fi
		sleep 5
	done
	echo "\"$(date +'%F %T')\" \"$instance_id\" \"$volume_id\" \"$volume_attached_id\"" >> $file_of_alived_node
}

if [ $# -le 3 ];then
	echo "Error: Usage $(basename $0) {create|delete} number"
	exit $Error_Parameter
fi


case $1 in 
	create)
		start_ip_number=5
		# file_of_ip_number restore have been create maximal ip 
		. $file_of_ip_number
		create_instance_number=0
		# Loop create node host
		while [[ $create_instance_number -lt $2 ]] && [[ $start_ip_number -le 250 ]];do  
			instance_display_name=iGB$(printf "%03d" $start_ip_number)
			instance_private_ip=10.40.1.$start_ip_number
			echo $instance_private_ip
			volume_display_name=vGB$(printf "%03d" $start_ip_number)
			volume_size_mbs=51200
			attachment_display_name=${instance_display_name}_attached_${volume_display_name}
			Create_Node $instance_display_name $instance_private_ip $volume_display_name $volume_size_mbs $attachment_display_name
			# alter create maximal ip
			start_ip_number=$((start_ip_number+1))
			echo "start_ip_number=$start_ip_number" >$file_of_ip_number  
			create_instance_number=$((create_instance_number+1))
		done
		echo "create $create_instance_number instance."
		;;
	delete)
		. $file_of_ip_number
		#end_delete_ip_number=$((start_create_ip_number-1))
		delete_instance_number=0
		while [ $delete_instance_number -lt $2 ];do
			instance_id=$(tail -1 $file_of_alived_node | cut -d "\"" -f 4)
			if [[ -z $instance_id ]];then
				echo "no have more instance"
				echo "delete $delete_instance_number instance."
				exit $Error_No_Instance		
			fi
			volume_id=$(tail -1 $file_of_alived_node | cut -d "\"" -f 6)

			$oci_path compute instance terminate --force --instance-id $instance_id
			while true;do
				instance_state=$($oci_path compute instance get --instance-id $instance_id |grep "lifecycle-state" |cut -d "\"" -f 4) 
				if [[ $instance_state == "TERMINATED" ]] || [[ -z $instance_state ]];then
					break
				fi
				sleep 5
			done
			$oci_path bv volume delete --force --volume-id $volume_id
			delete_instance_number=$((delete_instance_number+1))
			echo "\"$instance_id\" \"$volume_id\"" >> $file_of_delete_node_log
			# alter alived hosts
			sed -i "/$instance_id/d" $file_of_alived_node 
			echo "start_ip_number=$((start_ip_number-1))" >$file_of_ip_number  
		done
		echo "delete $delete_instance_number instance."
		;;
	*)
		echo "Usage: $(basename $0) {create|delete} number"
esac
