#!/bin/bash
yum update -y
yum install -y wget
cd /etc/yum.repos.d
wget http://download.openvz.org/openvz.repo
rpm --import http://download.openvz.org/RPM-GPG-Key-OpenVZ
yum install -y vzkernel.x86_64
yum install -y vzctl vzquota ploop
sed -i 's/kernel.sysrq = 0/kernel.sysrq = 1/g' /etc/sysctl.conf
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
echo 'net.ipv4.conf.default.proxy_arp = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.rp_filter = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.send_redirects = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.send_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.icmp_echo_ignore_broadcasts=1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.forwarding=1' >> /etc/sysctl.conf
sysctl -p
sed -i 's/NEIGHBOUR_DEVS=detect/NEIGHBOUR_DEVS=all/g' /etc/vz/vz.conf
sed -i 's/SELINUX=enabled/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/1/0/g' /etc/modprobe.d/openvz.conf
cd /vz/template/cache
wget http://download.openvz.org/template/precreated/centos-6-x86_64.tar.gz
yum install -y ntp
ntpdate -u us.pool.ntp.org
chkconfig ntpd on
iptables -F FORWARD
iptables -F INPUT
iptables -F OUTPUT
/etc/init.d/iptables save
