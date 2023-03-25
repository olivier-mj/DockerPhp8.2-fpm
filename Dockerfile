FROM php:8.2-fpm
LABEL maintainer="contact@oliviermariejoseph.fr"

RUN apt-get update && apt-get install -y \
	wget \
	git \
	nano

RUN apt-get update && apt-get install -y libzip-dev libicu-dev && docker-php-ext-install pdo zip intl opcache 

# Support de apcu
RUN pecl install apcu && docker-php-ext-enable apcu

# Support de redis
RUN pecl install redis && docker-php-ext-enable redis

# Support de Postgre
RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo_pgsql

# Support de MySQL (pour la migration)
RUN docker-php-ext-install mysqli pdo_mysql

# Imagick
# RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick 

# Extension Installler
RUN  curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions 

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions  gd imagick 
	
RUN docker-php-ext-install gd
RUN docker-php-ext-install imagick


RUN apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ADD php.ini /usr/local/etc/php/conf.d/

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Symfony tool
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
	mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Security checker tool
RUN curl -L https://github.com/fabpot/local-php-security-checker/releases/download/v${PHP_SECURITY_CHECHER_VERSION}/local-php-security-checker_${PHP_SECURITY_CHECHER_VERSION}_linux_$(dpkg --print-architecture) --output /usr/local/bin/local-php-security-checker && \
	chmod +x /usr/local/bin/local-php-security-checker

# Xdebug (disabled by default, but installed if required)
RUN pecl install xdebug-3.2.1 && docker-php-ext-enable xdebug
ADD php.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www

EXPOSE 9000