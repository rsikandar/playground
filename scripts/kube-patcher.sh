#!/bin/bash


#run from the jump as root

hostList=$(cat /etc/hosts |grep -v "#"| grep -v "::" | grep -v "ip-"| awk '{print $2}'| grep "kube")
FAILED=()
SUCCESS=()
ZFSUCCESS=()

for i in $hostList;
do

    zfs=$(ssh "$i" "df -h | grep zfs")
    linux=$(ssh -t "$i" "uname -r")
    echo ""
    echo "Working on '$i' currently!"
    echo ""
    sleep 5

        if [[ $linux == *"generic"* ]]
        then
            if [[ $linux == "3.13"* ]]
            then
                echo "Doing simple install, found 3.13"
                echo ""
                sleep 5
                ssh -t "$i" "mv /etc/apt/listchanges.conf /etc/apt/listchanges.conf.bak; apt-get install linux-virtual -y"
                SUCCESS+=("$i")
                SUCCESS+=("$(ssh  "$i" "hostname")")

            elif [[ $linux == "3.19"* ]]
            then
                echo "doing big install, found 3.19"
                echo ""
                sleep 5
                ssh -t "$i" "apt-get install linux-headers-generic-lts-xenial linux-image-generic-lts-xenial -y"
                SUCCESS+=("$i")
                SUCCESS+=("$(hostname)")

            else
                echo "Something is up with kernel version"
                FAILED+=("$i")
                FAILED+=("$(ssh  "$i" "hostname")")

            fi
        fi

# Check for ZFS!

        if [[ -n "$zfs" ]]
        then
            echo "ZFS FOUND! Setting it up for new kernel"
            echo ""
            sleep 5
            ssh -t "$i" "apt-get install spl-dkms; apt-get install zfs-dkms; apt-get install libzfs2 zfs-doc zfsutils"
            ZFSUCCESS+=("$i")
            ZFSUCCESS+=("$(ssh  "$i" "hostname")")
        else
            echo ""
            echo "ZFS NOT FOUND, moving on!"
            echo ""
            sleep 5
        fi


done
echo ""
echo "If nodes are listed below, possible failure:"
echo ""
echo "${FAILED[*]}" > ~/patching/FAILED
echo ""
echo "Kernel Installed on the following and will need to be rebooted:"
echo "${SUCCESS[*]}" > ~/patching/SUCCESS
echo ""
echo "ZFS installed on the following:"
echo "${ZFSUCCESS[*]}" > ~/patching/ZFS