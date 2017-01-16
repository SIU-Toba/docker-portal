FROM siutoba/docker-web:latest
MAINTAINER smarconi@siu.edu.ar


RUN apt-get update \
	&& apt-get install -y zlib1g-dev libicu-dev g++ libssl-dev libc-client2007e-dev libkrb5-dev php-pear libmemcached-dev libncurses5-dev \
    && docker-php-ext-install intl \
	&& docker-php-ext-install pdo_mysql \

	&& docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap \

    && npm install -g less \
	&& apt-get remove -y libldap2-dev libgmp-dev zlib1g-dev libicu-dev g++ libssl-dev libc-client2007e-dev libkrb5-dev libmemcached-dev zlib1g-dev libncurses5-dev php-pear \
    && rm -r /var/lib/apt/lists/*

RUN curl -L http://pecl.php.net/get/memcache-2.2.7.tgz >> /usr/src/php/ext/memcache.tgz && \
		tar -xf /usr/src/php/ext/memcache.tgz -C /usr/src/php/ext/ && \
		rm /usr/src/php/ext/memcache.tgz && \
		docker-php-ext-install memcache-2.2.7

#RUN chmod +x /entrypoint.d/*.sh

