#!/bin/bash
#
# CentOS 7 x86_64 LAMP Stack

## Root?
############
if [ "x$(id -u)" != 'x0' ]; then
    echo "You must be root to run this script."
    exit 1
fi
############

## CentOS?
############
if [ -e '/etc/redhat-release' ]

then

    echo " "

else

    echo "This script requires CentOS 7."
    exit 1

fi
############

## Define variables from user input.
############

echo "Enter the desired MySQL root password.";
echo -n "Password: ";
read SQLPASS;

############

yum install -y httpd mariadb-server mariadb at expect php php-mysql php-pear php-xml php-gd php-mbstring

sed -i 's/LoadModule\ mpm_prefork_module/#LoadModule\ mpm_prefork_module/g' /etc/httpd/conf.modules.d/00-mpm.conf
sed -i 's/#LoadModule\ mpm_event_module/LoadModule\ mpm_event_module/g' /etc/httpd/conf.modules.d/00-mpm.conf
sed -i 's/php_value/#php_value/g' /etc/httpd/conf.d/php.conf

systemctl enable httpd.service
systemctl enable mariadb.service
systemctl start mariadb
systemctl start httpd

mysqladmin -u root password "$SQLPASS"

## Secure MySQL
############
SECURE_MYSQL=$(expect -c "
set timeout 5
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$SQLPASS\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$SECURE_MYSQL"
############

echo "[client]" >> /root/.my.cnf
echo "user=root" >> /root/.my.cnf
echo "password=$SQLPASS" >> /root/.my.cnf

firewall-cmd --permanent --zone=public --add-port=80/tcp
systemctl restart firewalld.service

clear
echo "Done. Your files are to be hosted from /var/www/html."
