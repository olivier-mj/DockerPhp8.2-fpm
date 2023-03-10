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
	redis \
	cron g++ gettext libicu-dev openssl \
    libc-client-dev libkrb5-dev  \
    libxml2-dev libfreetype6-dev \
    libgd-dev libmcrypt-dev bzip2 \
    libbz2-dev libtidy-dev libcurl4-openssl-dev \
    libz-dev libmemcached-dev libxslt-dev git-core libpq-dev \
    libzip4 libzip-dev libwebp-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN 	docker-php-ext-install bcmath sockets iconv gettext event bz2 calendar amqp mysqli pdo_mysql pdo_pgsql pgsql soap xsl sockets zip exif memcached mcrypt intl apcu opcache  && \
			docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp &&\
    		docker-php-ext-install gd &&\
			docker-php-ext-configure hash --with-mhash &&\
			pecl install mongodb && docker-php-ext-enable mongodb &&\
    		pecl install redis && docker-php-ext-enable redis 



RUN echo '\
opcache.interned_strings_buffer=16\n\
opcache.load_comments=Off\n\
opcache.max_accelerated_files=16000\n\
opcache.save_comments=Off\n\
' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Security checker tool
RUN curl -L https://github.com/fabpot/local-php-security-checker/releases/download/v${PHP_SECURITY_CHECHER_VERSION}/local-php-security-checker_${PHP_SECURITY_CHECHER_VERSION}_linux_$(dpkg --print-architecture) --output /usr/local/bin/local-php-security-checker && \
	chmod +x /usr/local/bin/local-php-security-checker

ADD php.ini /usr/local/etc/php/conf.d/


WORKDIR /var/www

EXPOSE 9000