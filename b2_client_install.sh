# Installs B2 client on CentOS 6/7

yum install gcc sqlite-devel -y
cd /usr/src
wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
tar xzf Python-3.6.1.tgz
cd Python-3.6.1
./configure --enable-loadable-sqlite-extensions
make altinstall
pip3.6 install --upgrade pip
pip3.6 install --upgrade b2
