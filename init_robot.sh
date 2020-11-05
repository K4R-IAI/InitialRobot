#!/usr/bin/env bash

source /home/giangnguyen/Workspace/iai_donbot_ws/devel/setup.bash # Change this path on local system

storeName='Refills Lab'
hostname='ked.informatik.uni-bremen.de'

function get_id ()
{
	echo "Searching for store ID of $storeName..."
	for ((i=0;i<$(curl -s http://${hostname}:8090/k4r-core/api/v0/stores | jq '. | length');i++))
	do	
		if [[ $(curl -s http://${hostname}:8090/k4r-core/api/v0/stores | jq ".[$i] | .storeName") == \"$storeName\" ]]
		then	
			id=$(curl -s http://${hostname}:8090/k4r-core/api/v0/stores | jq ".[$i] | .id")
			echo "Store $storeName found with id $id"
		fi
	done
}

get_id

if [ -z "$id" ]
then
	echo "Store $storeName not found"
else
	roscd iai_donbot_unreal
  cd config
	echo -e "id: $id\nhostname: $hostname" > refills_lab.yaml
	echo "Created parameters for robot in $(pwd)"
fi