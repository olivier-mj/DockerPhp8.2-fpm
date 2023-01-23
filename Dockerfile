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
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pecl.php.net && \
    pecl install apcu igbinary mongodb && \
	pecl bundle redis && cd redis && phpize && ./configure --enable-redis-igbinary && make && make install && \
	docker-php-ext-configure gd --with-freetype --with-jpeg \
	docker-php-ext-install bcmath sockets  \
	imagick -j$(nproc) gd gettext event bz2 calendar amqp mysqli pdo_mysql pdo_pgsql pgsql soap xsl sockets zip redis exif memcached mcrypt intl apcu opcache  


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