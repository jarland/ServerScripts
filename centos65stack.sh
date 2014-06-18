#!/bin/bash
#
# CentOS 6.5 x86_64 LAMP Stack
# Set your MySQL root password below
SQLPASS="pass"

# Set the user/pass that the script will make for your first virtual host.
USER="user"
PASS="pass"

# Your e-mail address
ADMIN="user@domain.tld"

# The first virtual host added, domain without www
DOMAIN="domain.tld"

yum -y update
rpm -ivh http://epel.mirror.constant.com/6/i386/epel-release-6-8.noarch.rpm
yum -y install httpd mysql-server php php-pear php-xml php-mysql httpd-itk at wget php-gd php-mbstring
rpm -ivh https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm
service httpd restart
service mysqld start
mysql -e "DROP DATABASE test;"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$SQLPASS');"
mysql -e "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('$SQLPASS');"
mysql -e "SET PASSWORD FOR 'root'@'::1' = PASSWORD('$SQLPASS');"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u root password "$SQLPASS"
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
echo "NameVirtualHost *:80" >> /etc/httpd/conf.d/vhosts.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/vhosts.conf
echo "ServerAdmin $ADMIN" >> /etc/httpd/conf.d/vhosts.conf
echo "ServerName $DOMAIN" >> /etc/httpd/conf.d/vhosts.conf
echo "ServerAlias www.$DOMAIN" >> /etc/httpd/conf.d/vhosts.conf
echo "DocumentRoot /home/$USER/$DOMAIN/public_html/" >> /etc/httpd/conf.d/vhosts.conf
echo "ErrorLog /home/$USER/$DOMAIN/logs/error.log" >> /etc/httpd/conf.d/vhosts.conf
echo "CustomLog /home/$USER/$DOMAIN/logs/access.log combined" >> /etc/httpd/conf.d/vhosts.conf
echo "AssignUserId $USER $USER" >> /etc/httpd/conf.d/vhosts.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/vhosts.conf
sed -i 's/#HTTPD/HTTPD/g' /etc/sysconfig/httpd
sed -i 's/.worker/.itk/g' /etc/sysconfig/httpd
chkconfig httpd on
chkconfig mysqld on
service httpd restart
service mysqld restart
