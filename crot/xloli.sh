#!/bin/bash
pkill nginx
systemctl stop nginx
cat > /etc/nginx/conf.d/mantap.conf << END
stream{
    upstream tcpssh {
               server 127.0.0.1:999;  
    }
    server{
        listen 998;
        listen 998 udp;
        proxy_pass tcpssh;
    }
}
END
systemctl restart nginx
service nginx restart
