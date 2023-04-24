#!/bin/bash

home=/metacat

# start database server and create MetaCat database
su - -c "/usr/pgsql-12/bin/pg_ctl -D /var/lib/pgsql/12/data -l /var/lib/pgsql/logfile start" postgres
su - -c "createdb metacat" postgres
su - -c "psql -c \"CREATE USER metacat SUPERUSER PASSWORD 'metacatpassw0rd'\" metacat" postgres

# initialise MetaCat database and create admin user
export PYTHONPATH=/metacat/product
cd /metacat/product/metacat/ui
./metacat admin -c /config/config.yaml init
./metacat admin -c /config/config.yaml create admin admin


# original entrypoint.sh script
cp -R /config $home
chmod -R go+rx ${home}/config
chmod go-rwx ${home}/config/*.pem
chmod u-w ${home}/config/*.pem

cp /config/auth_server.conf /etc/httpd/conf.d/
if [ -f /etc/httpd/conf.d/zgridsite.conf ]; then
	mv /etc/httpd/conf.d/zgridsite.conf /etc/httpd/conf.d/zgridsite.conf-hide
fi


# token issuer
export METACAT_SERVER_TEMPLATES_DIR=${home}/auth_server
export AUTH_SERVER_CFG=${home}/config/config.yaml
export OPENSSL_ALLOW_PROXY_CERTS=1
httpd

# MetaCat server
cd ${home}

export METACAT_SERVER_TEMPLATES_DIR=${home}/server/templates
export METACAT_SERVER_CFG=${home}/config/config.yaml
export PYTHONPATH=`pwd`:`pwd`/wsdbtools

exec python -u server/Server.py

