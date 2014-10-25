#!/usr/bin/env bash

#
# This script installs the development environment.
#

# Require all variables to be set and exit on first error.
set -u
set -e

LOG='/vagrant/provisioning/provisioning.log'

APACHE_CONF='/etc/apache2/apache2.conf'
PHP_CONF='/etc/php5/apache2/php.ini'
XDEBUG_CONF='/etc/php5/mods-available/xdebug.ini'
MYSQL_CONF='/etc/mysql/my.cnf'

# Clear the log
> ${LOG}

# Make sure we're running as root
sudo su

# A quiet unattended installation
export DEBIAN_FRONTEND=noninteractive

echo 'Now provisioning.'
echo "Output and errors are logged into ${LOG}."

echo 'Upgrading the system...'

apt-get -qy update &>> ${LOG}
apt-get -qy upgrade &>> ${LOG}

echo 'Installing utilities...'

apt-get -qy install git-core curl &>> ${LOG}

echo 'Installing Apache...'

apt-get -qy install apache2 &>> ${LOG}

# Enable URL rewriting globally, doesn't need to be secure
a2enmod rewrite &>> ${LOG}
sed -i 's/AllowOverride\s+None/AllowOverride All/g' ${APACHE_CONF}

# Remove default Apache index page
rm -f /var/www/html/index.html &>> ${LOG}

echo 'Installing PHP...'

apt-get -qy install php5 php5-xsl php5-curl php5-mysql php5-mcrypt php5-gd \
                    php5-xdebug php-pear &>> ${LOG}

# Enable error reporting
sed -i 's/display_errors\s*=\s*Off/display_errors = On/g' ${PHP_CONF}

# Enable Xdebug
echo 'xdebug.remote_enable = On' >> ${XDEBUG_CONF}
echo 'xdebug.remote_connect_back = On' >> ${XDEBUG_CONF}

echo 'Installing MariaDB...'

# Set root password
echo 'mysql-server mysql-server/root_password password root' \
     | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root' \
     | debconf-set-selections

apt-get -qy install mariadb-server &>> ${LOG}

# Access MariaDB from outside the box
sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' ${MYSQL_CONF}

# Allow root login from anywhere
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' " \
     "WITH GRANT OPTION" | mysql -u root --password=root &>> ${LOG}

# Create a default database
echo 'CREATE DATABASE vagrant CHARACTER SET utf8 COLLATE utf8_unicode_ci' \
     | mysql -u root --password=root &>> ${LOG}

echo 'Starting server...'

service apache2 restart &>> ${LOG}
service mysql restart &>> ${LOG}

echo 'Done!'
