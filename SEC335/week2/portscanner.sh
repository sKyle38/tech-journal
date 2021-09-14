#!/bin/bash

hostfile=$1
portfile=$2
savefile=$3

#check if exists
if [[ -f "${savefile}" ]]
then
        #prompt for overwrite
        echo "The file ${savefile} exists."
        echo "Do you want to overwrite it? [y|N]"
        read to_overwrite

        if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" || "${to_overwrite}" == "n" ]]
        then
                echo "Exit..."
                exit 0

        elif [[ "${to_overwrite}" == "y" ]]
        then
                echo "Overwriting the save file..."
        else
                echo "Invalid value"
                exit 1
        fi
else
	touch "${savefile}"

fi

echo "host,port" > $savefile
for host in $(cat $hostfile); do
	for port in $(cat $portfile); do
		timeout .1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null &&
			echo "$host,$port"  >> $savefile
	done
done
