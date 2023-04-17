FROM php:8.1.0-apache

ENV DEBIAN_FRONTEND "noninteractive"
RUN set -e                                             ;\
  apt update                                           ;\
    apt install -y  \
        wget \
        git \
        subversion \
        libaio1 \
        libaio-dev

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

#    oci8 \
#

RUN set -e                                             ;\
  install-php-extensions \
    gd \
    pdo \
    xdebug-^3.1 \
    memcached \
    redis \
    @composer-2

ADD https://download.oracle.com/otn_software/linux/instantclient/185000/instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip /tmp/oracle/instantclient-sdk-linux.zip
ADD https://download.oracle.com/otn_software/linux/instantclient/185000/instantclient-basic-linux.x64-18.5.0.0.0dbru.zip /tmp/oracle/instantclient-basic-linux.zip
ADD https://download.oracle.com/otn_software/linux/instantclient/185000/instantclient-odbc-linux.x64-18.5.0.0.0dbru.zip /tmp/oracle/instantclient-odbc-linux.zip
ADD https://download.oracle.com/otn_software/linux/instantclient/185000/instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip /tmp/oracle/instantclient-sqlplus-linux.zip

RUN set -e                                                                 ;\
    mkdir /opt/oracle                                                      ;\
    unzip /tmp/oracle/instantclient-sdk-linux.zip -d           /opt/oracle ;\
    unzip /tmp/oracle/instantclient-basic-linux.zip -d         /opt/oracle ;\
    unzip /tmp/oracle/instantclient-odbc-linux.zip -d          /opt/oracle ;\
    unzip /tmp/oracle/instantclient-sqlplus-linux.zip -d       /opt/oracle ;\
    rm -rf /tmp/oracle                                                     ;\
    ls -l /opt/oracle

ENV LD_LIBRARY_PATH  /opt/oracle/instantclient_18_5:${LD_LIBRARY_PATH}

RUN echo /opt/oracle/instantclient_18_5/ > /etc/ld.so.conf.d/oic.conf && \
    ldconfig

RUN set -e                                                                                     ;\
  docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_18_5 ;\
  docker-php-ext-install pdo_oci


RUN set -e                                                                                     ;\
  echo 'instantclient,/opt/oracle/instantclient_18_5/' | pecl install oci8

RUN set -e                      ;\
  docker-php-ext-enable pdo_oci ;\
  docker-php-ext-enable oci8


workdir '/app'
COPY volume/configs configs
COPY volume/bin bin

ENTRYPOINT ["/app/bin/entrypoint.sh"]