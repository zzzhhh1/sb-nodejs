#!/bin/bash
export LANG=en_US.UTF-8
export uuid=${UUID:-''}
export domain=${DOMAIN:-''}
export vl_port=${PORT:-''}
username=$(whoami)
if [ -z $vl_port ]; then
vl_port=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $UUID ]; then
uuid=$(cat /proc/sys/kernel/random/uuid)
fi
curl -s -o "/home/$username/domains/$domain/public_html/index.js" "https://raw.githubusercontent.com/yonggekkk/vless-nodejs/beta/app.js"
curl -s -o "/home/$username/domains/$domain/public_html/package.json" "https://raw.githubusercontent.com/yonggekkk/vless-nodejs/beta/package.json"
sed -i "s/ccbfa010-f92b-49cf-8b4b-ae94b0fac112/$uuid/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/9527.9528/$domain/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/54321;/$vl_port;/g" "/home/$username/domains/$domain/public_html/index.js"
