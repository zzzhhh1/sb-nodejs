#!/bin/bash

hostname=$(hostname)
export uuid=${uuid:-'bc97f674-c578-4940-9234-0a1da46041b9'}
export port_vl_re=${vlpt:-'44444'}
export port_vm_ws=${vmpt:-'33333'}
export port_hy2=${hypt:-'22222'}
export port_tu=${tupt:-'11111'}
export ym_vl_re=${reym:-''}

curl -L -o sing-box  -# --retry 2 https://github.com/yonggekkk/vless-nodejs/releases/download/vlnodejs/sing-box
chmod +x sing-box
if [ -z $port_vl_re ]; then
port_vl_re=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $port_vm_ws ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $port_hy2 ]; then
port_hy2=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $port_tu ]; then
port_tu=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $uuid ]; then
uuid=$(./sing-box generate uuid)
fi
if [ -z $ym_vl_re ]; then
ym_vl_re=www.yahoo.com
fi

openssl ecparam -genkey -name prime256v1 -out private.key
openssl req -new -x509 -days 36500 -key private.key -out cert.pem -subj "/CN=www.bing.com"
if [ ! -e private_key ]; then
key_pair=$(/sing-box generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$(/sing-box generate rand --hex 4)
echo "$private_key" > private_key
echo "$public_key" > public.key
echo "$short_id" > short_id
fi

echo "Vless-reality端口：$port_vl_re"
echo "Vmess-ws端口：$port_vm_ws"
echo "Hysteria-2端口：$port_hy2"
echo "Tuic-v5端口：$port_tu"
echo "当前uuid密码：$uuid"
echo "当前reality域名：$ym_vl_re"
echo "当前reality pr key：$private_key"
echo "当前reality pu key：$public_key"
echo "当前reality id：$short_id"

cat > sb.json <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-sb",
      "listen": "::",
      "listen_port": ${port_vl_re},
      "users": [
        {
          "uuid": "${uuid}",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "${ym_vl_re}",
          "reality": {
          "enabled": true,
          "handshake": {
            "server": "${ym_vl_re}",
            "server_port": 443
          },
          "private_key": "$private_key",
          "short_id": ["$short_id"]
        }
      }
    },
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${uuid}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${uuid}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"    
        },
        "tls":{
                "enabled": false,
                "server_name": "www.bing.com",
                "certificate_path": "cert.pem",
                "key_path": "private.key"
            }
    },
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "cert.pem",
            "key_path": "private.key"
        }
    },
        {
            "type":"tuic",
            "tag": "tuic5-sb",
            "listen": "::",
            "listen_port": ${port_tu},
            "users": [
                {
                    "uuid": "${uuid}",
                    "password": "${uuid}"
                }
            ],
            "congestion_control": "bbr",
            "tls":{
                "enabled": true,
                "alpn": [
                    "h3"
                ],
                "certificate_path": "cert.pem",
                "key_path": "private.key"
            }
        }
    ],
"outbounds": [
{
"type":"direct",
"tag":"direct"
}
]
}
EOF
nohup ./sing-box run -c sb.json >/dev/null 2>&1 &

private_key=$(< private_key)
public_key=$(< public.key)
short_id=$(< short_id)
server_ip=$(curl -s4m5 icanhazip.com -k)
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key&sid=$short_id&type=tcp&headerType=none#vl-reality-$hostname"
echo "$vl_link" > jh.txt

vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> jh.txt

hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&sni=www.bing.com#hy2-$hostname"
echo "$hy2_link" >> jh.txt

tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&allow_insecure=1#tu5-$hostname"
echo "$tuic5_link" >> jh.txt

jh_txt=$(cat jh.txt)

cat > list.txt <<EOF
---------------------------------------------------------
---------------------------------------------------------
节点配置输出：
【 vless-reality-vision 】节点信息如下：
$vl_link

【 vmess-ws 】节点信息如下：
$vm_link

【 Hysteria-2 】节点信息如下：
$hy2_link

【 Tuic-v5 】节点信息如下：
$tuic5_link

聚合节点：
$jh_txt
---------------------------------------------------------
EOF
cat list.txt
