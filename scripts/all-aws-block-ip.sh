#!/bin/bash -e

# This script finds IAM users who have MFA and Passwords.
# Adds to Office IP only group.
accounts="lvl lvp nmlv"
grpup="NMLViP"
# Which AWS account
for k in $accounts
do 


# Generate a report
AWS_PROFILE=$k aws iam generate-credential-report > /dev/null

# Download report.
REPORT=$(AWS_PROFILE=$k aws iam get-credential-report)

# Parse the good stuff from the JSON
DATA=$(echo ${REPORT}|jq ".Content" -r)

# User with MFA and Password get added to a list
MFAUSERS=$(echo ${DATA} | base64 --decode | cut -d, -f1,4,8 | grep "true,true$" | cut -d, -f1)

# Attach Blocking Policy to users with MFA and Password.
function attach {
    for i in $MFAUSERS
    do 
    AWS_PROFILE=$k aws iam add-user-to-group --user-name $i --group-name $group
    done
}
attach


done