FROM php:8.2-fpm
LABEL maintainer="contact@oliviermariejoseph.fr"

ENV PHP_SECURITY_CHECHER_VERSION=2.0.6

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
	curl \
	git\
	nano \
	unzip \
	zip \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
	install-php-extensions imagick gd gettext event bz2 calendar amqp mysqli pdo_mysql pdo_pgsql pgsql soap xsl sockets zip redis exif memcached mcrypt intl apcu opcache  

# Security checker tool
RUN curl -L https://github.com/fabpot/local-php-security-checker/releases/download/v${PHP_SECURITY_CHECHER_VERSION}/local-php-security-checker_${PHP_SECURITY_CHECHER_VERSION}_linux_$(dpkg --print-architecture) --output /usr/local/bin/local-php-security-checker && \
	chmod +x /usr/local/bin/local-php-security-checker

ADD php.ini /usr/local/etc/php/conf.d/


WORKDIR /var/www

EXPOSE 9000