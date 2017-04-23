ServerScripts
=============

Scripts that I use to configure my servers.

$ centos65stack.sh<br>
Made for CentOS 6.5. This installs Apache, MySQL, MPM-ITK, Varnish, and PHP. This secures MySQL, creates a user/pass for single domain, creates virtual host entries and folders for one domain. You will be asked for the variables upon running the script.

$ installopenvz-cent6.sh<br>
Installs OpenVZ and downloads all templates on CentOS 6. Run this, reboot when it asks you to. Done.

$ vzup.sh<br>
Immature version of an OpenVZ container creation script, thrown together at a moment's notice. Needs some love.

$ centos7lamp.sh<br>
A very flawed LAMP config for CentOS 7. Apache 2.4 and PHP 5.6. This would be better renamed to "slowly_oom_your_box.sh" if you catch my drift. Apache consumes memory to no end, with no provocation, in this particular recipe.

$ block_user_agents<br>
This consists of bots that ignore robots.txt and user agents that frequently probed for script vulnerabilities. This is no longer maintained and will not be updated.

$ b2_client_install.sh<br>
Installs Backblaze B2 client on CentOS 6/7
