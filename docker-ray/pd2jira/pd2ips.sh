#!/bin/bash

#variables
pdips=`dig a +short webhooks.pagerduty.com`
whitelist=/etc/nginx/conf.d/white_list.conf

#remove old ips using tags
sed -i '/#pdstart/,/#pdend/d' $whitelist

#pd ips start tag
echo '#pdstart' >> $whitelist

#loop to add ips
for i in $pdips
do
echo allow $i\; >> $whitelist
done

#pd ips end tag
echo '#pdend' >> $whitelist


#reload Nginx settings
service nginx reload