FROM ubuntu:16.04
MAINTAINER Frank Villaro-Dixon <docker-overpass-api@vi-di.fr>

RUN apt-get update

RUN apt-get install -y apache2 nano
RUN apt-get install -y ca-certificates build-essential gawk texinfo pkg-config gettext automake libtool bison flex zlib1g-dev libgmp3-dev libmpfr-dev libmpc-dev git zip sshpass mc curl python expect bc telnet openssh-client tftpd-hpa libid3tag0-dev gperf libltdl-dev  autopoint

RUN apt-get install -y \
	autoconf \
	automake1.11 \
	expat \
	g++ \
	libtool \
	libexpat1-dev \
	make \
	zlib1g-dev \
	bzip2 \
	wget \
	liblz4-1 liblz4-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN git clone https://github.com/drolbr/Overpass-API.git
#WORKDIR /Overpass-API
#Checkout latest version
#RUN git checkout $(git describe --abbrev=0 --tags)
COPY Overpass-API /Overpass-API
RUN chmod +x /Overpass-API/src/bin/*.sh
#Configure
WORKDIR /Overpass-API/src
RUN \
	autoscan && \
	aclocal-1.11 && \
	autoheader && \
	libtoolize && \
	automake-1.11 --add-missing && \
	autoconf

#Compile
RUN \
	./configure --enable-lz4 CXXFLAGS="-O2" --prefix="`pwd`" && \
	make -j $(nproc --all)


COPY vhost_apache.conf /etc/apache2/sites-available
RUN a2enmod ext_filter cgi
RUN a2dissite 000-default.conf
RUN a2ensite vhost_apache.conf

WORKDIR /

COPY *.sh /
RUN chmod +x *.sh

ADD www /www

RUN useradd overpass_api

CMD ["/run.sh"]

VOLUME "/overpass_DB"
EXPOSE 80


