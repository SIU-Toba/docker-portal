FROM siutoba/docker-web:latest
MAINTAINER smarconi@siu.edu.ar


RUN apt-get update \
	&& apt-get install -y nodejs npm \
	&& apt-get install -y libldap2-dev libgmp-dev zlib1g-dev libicu-dev g++ \
	&& apt-get install -y libssl-dev libc-client2007e-dev libkrb5-dev \
	&& apt-get install -y \php-pear curl libmemcached-dev zlib1g-dev libncurses5-dev \

    && docker-php-ext-install intl \

	&& docker-php-ext-install pdo_mysql \

	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \

  	&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && docker-php-ext-configure gmp --with-gmp=/usr/include/x86_64-linux-gnu \
    && docker-php-ext-install gmp \

	&& docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap \

	#memcache
	&& curl -L http://pecl.php.net/get/memcache-2.2.7.tgz >> /usr/src/php/ext/memcache.tgz && \
		tar -xf /usr/src/php/ext/memcache.tgz -C /usr/src/php/ext/ && \
		rm /usr/src/php/ext/memcache.tgz && \
		docker-php-ext-install memcache-2.2.7 \

    && npm install -g less \
	&& apt-get remove -y libldap2-dev libgmp-dev zlib1g-dev libicu-dev g++ libssl-dev libc-client2007e-dev libkrb5-dev libmemcached-dev zlib1g-dev libncurses5-dev php-pear curl \
    && rm -r /var/lib/apt/lists/*


COPY portal.sh /entrypoint.d/

COPY portal.conf /etc/apache2/sites-enabled/portal.conf

RUN chmod +x /entrypoint.d/*.sh

