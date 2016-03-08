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

#RUN wp --path=/var/www/html core download --allow-root && \
#wp --path=/var/www/html core config --dbname=wpowasp --dbuser=root --dbpass=owasp --allow-root && \
#wp --path=/var/www/html core install --url=www.owasp-sevilla.org \
#--admin_name=owasp --admin_email=owasp@owasp.jarl \
#--admin_password=owasp --allow-root && \
#wp plugin install clikstats --activate --allow-root

RUN mysql -uroot -e "create database wpowasp"
# PoC sobre clikstats wp-content/plugins/clikstats/ck.php?Ck_id=514&Ck_lnk=http://owasp.org
# mas informacion en https://www.intelligentexploit.com/view-details.html?id=23276

#RUN chown -R www-data:www-data /var/www/html/

# descargamos reglas de owasp para modsecurity https://github.com/SpiderLabs/owasp-modsecurity-crs
# OWASP ModSecurity Core Rule Set (CRS) Project (Official Repository)
# ADD https://github.com/SpiderLabs/owasp-modsecurity-crs /tmp/

# activar modulos

#RUN a2enmod env ssl rewrite

# exponemos 80
EXPOSE 80

#Ejecucion
#CMD /bin/bash -c "service apache2 restart"
