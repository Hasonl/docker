[root@harbor_164 lnmp]# cat Dockerfile 
FROM centos
MAINTAINER xiao.hai
ENV VERSION=7.2.4
RUN echo "Asia/Shanghai" > /etc/timezone && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN yum install epel-release -y && \
    yum install -y vim gcc gcc-c++ make gd-devel libxml2-devel \
    libcurl-devel libjpeg-devel libpng-devel openssl-devel \
    libmcrypt-devel libxslt-devel libtidy-devel autoconf \
    iproute net-tools telnet wget curl && \
    yum clean all && \
    rm -rf /var/cache/yum/* 

ADD php-7.2.4 /usr/local/php-7.2.4
RUN groupadd www && useradd -g www -s /sbin/nologin -M www
RUN cd /usr/local/php-7.2.4 && ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --enable-fpm --enable-opcache --with-fpm-user=www \
    --with-fpm-group=www --with-mysqli --with-pdo-mysql \
    --with-openssl --with-zlib --with-curl --with-gd \
    --with-jpeg-dir --with-png-dir --with-freetype-dir \
    --enable-mbstring --with-mcrypt --enable-hash && \
    make -j 4 && make install && \
    cp php.ini-production /usr/local/php/etc/php.ini && \
    cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
    cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf && \
    sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /usr/local/php/etc/php-fpm.d/www.conf && \
    sed -i "90a \daemonize = no" /usr/local/php/etc/php-fpm.conf && \
    mkdir /usr/local/php/log && \
    cd /usr/local && rm -rf php-7.2.4 

ADD php-fpm.conf /usr/local/php/etc/       #将自定义的php-fpm.conf配置添加到容器

ENV PATH $PATH:/usr/local/php/sbin
WORKDIR /usr/local/php
EXPOSE 9000
CMD ["sbin/php-fpm","-c","etc/php-fpm.conf"]
