FROM php:7-apache

RUN apt-get update

RUN apt-get install -y vim git

# Install gd
RUN apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd

# Install intl
RUN apt-get install -y \
    libicu-dev \
  && docker-php-ext-install -j$(nproc) intl

# Install mcrypt
RUN apt-get install -y \
    libmcrypt-dev \
  && docker-php-ext-install -j$(nproc) mcrypt

# Install opcache
RUN docker-php-ext-install -j$(nproc) opcache

# Install MySQL
RUN apt-get install -y \
    mariadb-client \
  && docker-php-ext-install mysqli pdo_mysql

# Install cURL
RUN apt-get install curl

# Install symfony command tool
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

RUN a2enmod rewrite headers expires

COPY default.conf /etc/apache2/conf-available/app.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
RUN a2enconf app.conf
RUN a2dissite 000-default

ENV GOSU_VERSION 1.9
RUN set -x \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENV PATH /app/vendor/bin:$PATH

RUN useradd --shell /bin/bash -c "" -m user
#RUN mkdir -p /opt/drupal/files/public /opt/drupal/files/private
#RUN chown -R user:user /opt/drupal/files/public /opt/drupal/files/private
#RUN chmod 0777 /opt/drupal/files/public /opt/drupal/files/private

EXPOSE 80
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
