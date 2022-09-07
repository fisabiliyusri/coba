#!/bin/bash
touch /etc/nginx/conf.d/alone.conf
cat <<EOF >>/etc/nginx/conf.d/alone.conf
server {
	listen 61;
	listen [::]:61;
	server_name ${domain};
	# shellcheck disable=SC2154
	return 301 https://0.0.0.0;
}
server {
		listen 127.0.0.1:666;
		server_name _;
		return 403;
}
server {
	listen 127.0.0.1:666;
	server_name localhost;
	root /usr/share/nginx/html;
	location /s/ {
		add_header Content-Type text/plain;
		alias /etc/xray/config-url/;
	}
	location / {
		add_header Strict-Transport-Security "max-age=15552000; preload" always;
	}
}
EOF
