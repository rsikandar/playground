#!/bin/bash


#run from the jump as root

hostList=$(cat /etc/hosts |grep -v "#"| grep -v "::" | grep -v "ip-"| awk '{print $2}')
FAILED=()
SUCCESS=()

for i in $hostList;
do

    linux=$(ssh -t "$i" "uname -r")
    echo ""
    echo "Working on '$i' currently!"
    echo ""

        if [[ $linux == *"generic"* ]]
        then
            if [[ $linux == *"3.13.0-141-generic"* ]]
            then
                echo "'$i' is GOOD"
                SUCCESS+=("$i")
                SUCCESS+=("$(ssh  "$i" "hostname")")

            elif [[ $linux == *"4.4.0-112-generic"* ]]
            then
                echo "'$i' is good"
                SUCCESS+=("$i")
                SUCCESS+=("$(hostname)")

            else
                echo " '$i' NOT GOOD"
                FAILED+=("$i")

            fi
        fi


done
echo ""
echo "GOOD:"
echo "${SUCCESS[*]}"
echo ""
echo ""
echo "FAILED:"
echo "${FAILED[*]}"