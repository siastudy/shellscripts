#!/bin/bash

echo '>>> updating sources...'
sudo apt-get  update

echo '>>>installing python'
sudo apt-get -y install python-pip
sudo apt-get -y install python-m2crypto
sudo apt-get -y install openssl

echo '>>>installing shadowsocks'
sudo pip install shadowsocks

sudo touch /etc/shadowsocks.json

sudo cat '{
"server":"your_server_ip",
"server_port":8000,
"local_port":1080,
"password":"your_passwd",
"timeout":600,
"method":"aes-256-cfb"
}' > shadowsocks.json

echo '>>>starting shadowsocks...'
sudo ssserver -c /etc/shadowsocks.json -d start

res = `ps aux | grep shadowsocks`
if [[ $res =~ '/etc/shadowsocks.json -d start' ]]; then
	echo 'shadowsocks has started!'
	echo "PID: " echo $res | awk 'print $2'
fi

