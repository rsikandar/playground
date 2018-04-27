FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TERM xterm
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Utilities
RUN apt-get update && apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc
RUN apt-get install -y build-essential
RUN apt-get install -y libfontconfig

RUN mkdir -p /var/log/pd2jira
RUN apt-get install -y runit
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc



RUN apt-get update && apt-get install -y \
		apache2 \
		php5 \
		php5-curl

COPY src/ /var/www/html/
COPY sv /etc/service
RUN chown www-data:www-data /var/www/html/*

#remove configs before replacing
RUN rm -f /etc/apache2/apache2.conf
RUN rm -f /etc/apache2/envvars
RUN rm -f /var/www/html/index.html
RUN rm -f /etc/apache2/sites-enabled/000-default.conf
RUN rm -f /etc/apache2/conf-enabled/other-vhosts-access-log.conf
RUN rm -f /etc/php5/apache2/php.ini



#add new configs
COPY config/apache2.conf /etc/apache2/
COPY config/envvars /etc/apache2/
COPY config/000-default.conf /etc/apache2/sites-enabled/
COPY sv /etc/service
COPY config/php.ini /etc/php5/apache2/

#proper perms for run files for services
RUN chmod +x $(find /etc/service -name run)

EXPOSE 80 

WORKDIR /var/www/html/pd2jira