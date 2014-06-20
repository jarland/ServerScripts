#!/bin/bash
#
# CentOS 6.5 x86_64 LAMP Stack

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

    echo "This script requires CentOS 6."
    exit 1

fi
############

## Define variables from user input.
############
echo "Input the username for your virtual host (will be /home/username)";
echo -n "User: "
read USER;

echo " ";

echo "Input the password you want to set for the username.";
echo -n "Password: ";
read PASS;

echo " ";

echo "Enter the desired MySQL root password.";
echo -n "Password: ";
read SQLPASS;

echo " ";

echo "Enter the domain name you want to set up, do not include wwww.";
echo -n "Domain: ";
read DOMAIN;
############

yum -y update
rpm -ivh http://mirror.pnl.gov/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install httpd mysql-server php php-pear php-xml php-mysql httpd-itk at wget php-gd php-mbstring nano expect varnish
rpm -ivh https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm

sed -i 's/VARNISH_LISTEN_PORT=6081/VARNISH_LISTEN_PORT=80/g' /etc/sysconfig/varnish
sed -i 's/80/8080/g' /etc/varnish/default.vcl
sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

service httpd restart
service mysqld start
mysqladmin -u root password "$SQLPASS"

## Secure MySQL
############
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \”$SQLPASS\r\”
expect \"Change the root password?\"
send \”n\r\”
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

sed -i 's/error\_reporting\ \=/#error\_reporting\ \=/g' /etc/php.ini
echo "error_reporting = E_COMPILE_ERROR|E_RECOVERABLE_ERROR|E_ERROR|E_CORE_ERROR" >> /etc/php.ini
echo "error_log = /var/log/php.log" >> /etc/php.ini
sed -i 's/max\_execution\_time\ \=\ 30/max\_execution\_time\ \=\ 300/g' /etc/php.ini
sed -i 's/memory\_limit\ \=/#memory\_limit\ \=/g' /etc/php.ini
echo "memory_limit = 256M" >> /etc/php.ini
echo "<IfModule itk.c>" >> /etc/httpd/conf.d/php.conf
echo "LoadModule php5_module modules/libphp5.so" >> /etc/httpd/conf.d/php.conf
echo "</IfModule>" >> /etc/httpd/conf.d/php.conf
adduser $USER
echo "$PASS" | passwd "$USER" --stdin
mkdir -p /home/$USER/$DOMAIN/{public_html,logs}
chown -R $USER. /home/$USER
touch /etc/httpd/conf.d/vhosts.conf
echo "NameVirtualHost *:8080" >> /etc/httpd/conf.d/vhosts.conf
echo "<VirtualHost *:8080>" >> /etc/httpd/conf.d/vhosts.conf
echo "ServerName $DOMAIN" >> /etc/httpd/conf.d/vhosts.conf
echo "ServerAlias www.$DOMAIN" >> /etc/httpd/conf.d/vhosts.conf
echo "DocumentRoot /home/$USER/$DOMAIN/public_html/" >> /etc/httpd/conf.d/vhosts.conf
echo "ErrorLog /home/$USER/$DOMAIN/logs/error.log" >> /etc/httpd/conf.d/vhosts.conf
echo "CustomLog /home/$USER/$DOMAIN/logs/access.log combined" >> /etc/httpd/conf.d/vhosts.conf
echo "AssignUserId $USER $USER" >> /etc/httpd/conf.d/vhosts.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/vhosts.conf
sed -i 's/#HTTPD/HTTPD/g' /etc/sysconfig/httpd
sed -i 's/.worker/.itk/g' /etc/sysconfig/httpd
echo "[Client]" >> /root/.my.cnf
echo "User=root" >> /root/.my.cnf
echo "Password=$SQLPASS" >> /root/.my.cnf
chkconfig httpd on
chkconfig mysqld on
chkconfig varnish on
service httpd restart
service mysqld restart
service varnish start
clear
echo "Installation complete. The content for $DOMAIN will be hosted in"
echo "/home/$USER/$DOMAIN/public_html."
