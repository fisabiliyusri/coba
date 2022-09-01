#!/bin/bash
#setup
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
#
domain=$(cat /root/domain)
sleep 1
mkdir -p /etc/xray
echo "installing all needed tools"
echo "menginstal semua alat yang dibutuhkan"
echo "Progress..."
echo "Sedang berlangsung..."
sleep 3
echo "please read, the process of installing all scripts takes 10 minutes to 30 minutes"
echo "silahkan dibaca, proses pemasangan semua script memakan waktu 10 menit sampai 30 menit"
echo "do not exit terminal or application"
echo "jangan keluar dari terminal atau aplikasi"
echo -e "[ ${green}INFO${NC} ] in the process of installing tools"
echo -e "[ ${green}INFO${NC} ] dalam proses pemasangan alat"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing OpenSSH"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal OpenSSH"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing Dropbear"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal Dropbear"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing SlowDNS"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal SlowDNS"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing SSH Websocket"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal SSH Websocket"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing SSLH"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal SSLH"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing Stunnel"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal Stunnel"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing Certificate"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal Sertifikat"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing Nginx"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal Nginx"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing XRAY"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal XRAY"

sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading and Installing MENU"
echo -e "[ ${green}INFO${NC} ] Mengunduh dan Menginstal MENU"


#restart
sleep 1
echo -e "[ ${green}SERVICE${NC} ] Restart All service"
systemctl daemon-reload

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart SSH OpenSSH Dropbear"
systemctl restart sshd
/etc/init.d/ssh restart
systemctl enable dropbear
systemctl restart dropbear
/etc/init.d/dropbear restart

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart SSH SlowDNS"
systemctl restart sshd
pkill sldns-server
pkill sldns-client
systemctl stop client-sldns
systemctl stop server-sldns
systemctl enable client-sldns
systemctl enable server-sldns
systemctl start client-sldns
systemctl start server-sldns
systemctl restart client-sldns
systemctl restart server-sldns

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart NGINX  "
systemctl enable nginx
systemctl restart nginx
/etc/init.d/nginx restart

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart SSH Websocket "
systemctl enable ws-sl
systemctl restart ws-sl

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart SSLH "
systemctl enable sslh
systemctl restart sslh
/etc/init.d/sslh restart

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart Stunnel "
systemctl enable stunnel5
systemctl restart stunnel5
/etc/init.d/stunnel5 restart

sleep 1
echo -e "[ ${green}SERVICE${NC} ]  Enable & restart xray "
systemctl enable xray
systemctl restart xray
systemctl restart nginx


