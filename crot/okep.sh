#!/bin/bash
clear

apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Kuala_Lumpur
chronyc sourcestats -v
chronyc tracking -v
date


# CHECK VERSION XRAY CORE
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"

# Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"

# Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray

# Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# Make Folder XRay
mkdir -p /var/log/xray/

# Stop port 80
sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill


#
/etc/init.d/nginx stop
systemctl stop nginx
systemctl stop xray
systemctl stop xraysuper

# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.5.6
#
uuid=$(cat /proc/sys/kernel/random/uuid)
#uuid=b8458948-a630-4e6d-809a-230b2223ff3d

# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
# buat config server
cat> /etc/xray/xrayconfig.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
    "inbounds": [
        {
            "port": 888,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-direct",
                        "level": 0
#xray-vless-xtls
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 1310,
                        "xver": 1
                    },
                    {
                        "path": "/xray-vmessws-tls",
                        "dest": 1311,
                        "xver": 1
                    },
                    {
                        "path": "/xray-vlessws-tls",
                        "dest": 1312,
                        "xver": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "${path_crt}",
                            "keyFile": "${path_key}"
                        }
                    ]
                }
            }
        },
        {
            "port": 1310,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "${uuid}"
#trojan
                    }
                ],
                "fallbacks": [
                    {
                        "dest": 80
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none",
                "tcpSettings": {
                    "acceptProxyProtocol": true
                }
            }
        },
        {
            "port": 1311,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "alterId": 0,
                        "level": 0
#xray-vmess-tls
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "/xray-vmessws-tls"
                }
            }
        },
        {
            "port": 1312,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid5}",
                        "level": 0
#xray-vless-tls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "/xray-vlessws-tls"
                }
            }
        }
    ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}
END

# starting xray vmess ws tls core on sytem startup
cat> /etc/systemd/system/xraysuper.service << END
[Unit]
Description=Xray Super Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/xrayconfig.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

END

# enable xray
systemctl daemon-reload
systemctl enable xray.service
systemctl start xray.service
systemctl restart xray
# enable super
systemctl daemon-reload
systemctl enable xraysuper.service
systemctl start xraysuper.service
systemctl restart xraysuper
#
cd
