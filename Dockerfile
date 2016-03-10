############################################################
# Dockerfile para el taller de modsecurity de Owasp-Sevilla
# https://github.com/melozo/owaspSevilla-modsec.git 
# DATE: 07/03/2016
# carmelo.zubeldia@gmail.com
############################################################

FROM debian:7

# Autor
MAINTAINER Carmelo Zubeldia carmelo.zubeldia@gmail.com

# Instalacion de apache, php5, mysql, modsecurity
# ENV MYSQL_PASS=owasp

RUN apt-get clean all && \
apt-get -y update && \
apt-get -y upgrade && \
apt-get -y install libapache2-modsecurity php5 php5-cli php5-common php5-mysql mysql-client-5.5 \
mysql-common mysql-server-5.5 unzip wget curl 

# limpiamos y liberamos
RUN apt-get clean && rm -fr /var/lib/apt/lists/* && rm -f /etc/apache2/sites-available/*

#configuracion de apache
ADD 000-default.conf /etc/apache2/sites-enabled/
RUN cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

# Instalacion de wp-cli (http://wp-cli.org/)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
mv wp-cli.phar /usr/local/bin/wp

# instalamos wordpress en /var/www/html y plugin vulnerable clikstats

RUN rm -f /var/www/html/*

# aniadimos scripts de tutum/lamp/wordpress
# https://github.com/tutumcloud/wordpress/blob/master/Dockerfile

ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD create_db.sh /create_db.sh
RUN chmod +x /*.sh

EXPOSE 80
