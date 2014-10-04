ServerScripts
=============

Scripts that I use to configure my servers.

$ centos65stack.sh<br>
Made for CentOS 6.5. This installs Apache, MySQL, MPM-ITK, Varnish, and PHP. This secures MySQL, creates a user/pass for single domain, creates virtual host entries and folders for one domain. You will be asked for the variables upon running the script.

$ vzup.sh<br>
Immature version of an OpenVZ container creation script, thrown together at a moment's notice. Needs some love.

$ centos7lamp.sh<br>
A very flawed LAMP config for CentOS 7. Apache 2.4 and PHP 5.6, and Apache slowly consumes the system memory and never releases it, until it goes OOM. Don't use this.
