[root@localhost nginx]# cat Dockerfile 
FROM docker.io/centos 
MAINTAINER xiaohai
RUN yum install -y wget lrzsz gcc gcc-c++ make \
openssl-devel pcre-devel gd-devel libxslt-devel \
iproute vim net-tools telnet wget curl && \
yum clean all && \
rm -rf /var/cache/yum/*
RUN useradd -M -s /sbin/nologin www

RUN wget http://nginx.org/download/nginx-1.12.2.tar.gz && \
tar -zvxf nginx-1.12.2.tar.gz && \
cd nginx-1.12.2 && \
./configure --prefix=/usr/local/nginx \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_image_filter_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-stream \
--user=www \
--group=www \	
--with-stream_ssl_module && \
make -j 4 && make install && \
mkdir -p /usr/local/nginx/conf/vhost && \
cd / && rm -rf nginx-1.12.2*
ENV PATH $PATH:/usr/local/nginx/sbin
WORKDIR /usr/local/nginx
COPY nginx.conf /usr/local/nginx/conf/nginx.conf 
COPY basic.conf /usr/local/nginx/conf/vhost/basic.conf
COPY index.html /usr/local/nginx/html/index.html
EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
