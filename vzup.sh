#!/bin/bash

echo "Container ID: "
read ctid

echo "OS: "
read os

echo "Hostname: "
read hn

echo "IP Address: "
read ip

echo "Memory: "
read mem

echo "Disk Size: "
read disk

vzctl create $ctid --ostemplate $os
vzctl set $ctid --ipadd $ip --physpages $mem:$mem --diskspace $disk:$disk --nameserver 8.8.4.4 --nameserver 8.8.8.8 --hostname $hn --save
vzctl start $ctid
