#!/bin/bash -e


BUCKETS=`cat /Users/rsikandar/playground/scripts/buckets.txt`


for i in $BUCKETS
do 
    AWS_PROFILE=analytics-poc aws s3api put-bucket-versioning --bucket $i --versioning-configuration Status=Enabled
    echo $i 

done