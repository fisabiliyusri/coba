#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt install ssl-cert -y
apt install ca-certificate -y
apt-get remove --purge ufw firewalld -y
apt-get install gawk -y &>/dev/null
apt-get remove --purge exim4 -y
apt-get purge apache2* -y
rm -rf /etc/apache2
dpkg --configure -a &>/dev/null
# install wget and curl
apt -y install wget curl

# Install Requirements Tools
apt-get install grep -y &>/dev/null
apt install python3-pip -y
apt-add-repository universe -y &>/dev/null
apt-get install software-properties-common -y &>/dev/null
apt install ruby -y
apt install python -y
apt install make -y
apt install cowsay -y
apt install figlet -y
apt install lolcat -y
apt install cmake -y
apt install ncurses-utils -y
apt install coreutils -y
apt install rsyslog -y
apt install net-tools -y
apt install zip -y
apt install unzip -y
apt install nano -y
apt install sed -y
apt install gnupg -y
apt install gnupg1 -y
apt install gnupg2 -y
apt install bc -y
apt install jq -y
apt install apt-transport-https -y
apt install build-essential -y
apt install dirmngr -y
apt install libxml-parser-perl -y
apt install neofetch -y
apt install git -y
apt install lsof -y
apt install libsqlite3-dev -y
apt install libz-dev -y
apt install gcc -y
apt install g++ -y
apt install libreadline-dev -y
apt install zlib1g-dev -y
apt install libssl-dev -y
gem install lolcat
apt install jq curl -y
apt install dnsutils jq -y
apt-get install tcpdump -y
apt-get install dsniff -y
apt install grepcidr -y
#
apt install iptables iptables-persistent -y
sleep 1
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 1
systemctl enable chronyd
systemctl restart chronyd
sleep 1
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
sleep 1
chronyc sourcestats -v
chronyc tracking -v
sleep 1
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y
