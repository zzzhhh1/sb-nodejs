#!/bin/bash
export LANG=en_US.UTF-8
export uuid=${UUID:-''}
export domain=${DOMAIN:-''}
export vl_port=${PORT:-''}
username=$(whoami)
if [ -z $vl_port ]; then
vl_port=$(shuf -i 10000-65535 -n 1)
fi
curl -s -o "/home/$username/domains/$domain/public_html/app.js" "https://raw.githubusercontent.com/yonggekkk/vless-nodejs/beta/app.js"
curl -s -o "/home/$username/domains/$domain/public_html/package.json" "https://raw.githubusercontent.com/yonggekkk/vless-nodejs/beta/package.json"
sed -i "s/('UUID', '')/('UUID', '$uuid')/g" "/home/$username/domains/$domain/public_html/app.js"
sed -i "s/('DOMAIN', '')/('DOMAIN', '$domain')/g" "/home/$username/domains/$domain/public_html/app.js"
sed -i "s/('PORT', '')/('PORT', '$vl_port')/g" "/home/$username/domains/$domain/public_html/app.js"
echo "安装结束"
