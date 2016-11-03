FROM debian:jessie

MAINTAINER NGINX Docker Maintainers ""

ENV NGINX_VERSION 1.11.5-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
#RUN ln -sf /dev/stdout /var/log/nginx/access.log \
#	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get update
RUN apt-get install curl lsb-release -y
RUN curl -O https://repo.stackdriver.com/stack-install.sh
RUN apt-get install libyajl2 -y
RUN apt-get install rsyslog -y
RUN curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
RUN bash install-logging-agent.sh
RUN curl -O https://repo.stackdriver.com/stack-install.sh
RUN bash stack-install.sh --write-gcm

EXPOSE 80 443
#CMD bash install-logging-agent.sh && nginx -g daemon off;
#CMD /etc/init.d/google-fluentd start  && service nginx start
#CMD service nginx start
#CMD ["nginx", "-g", "daemon off;"]
COPY start.sh /usr/local/start.sh
COPY status.conf /etc/nginx/conf.d/status.conf
COPY nginx.conf /opt/stackdriver/collectd/etc/collectd.d/nginx.conf
CMD ["/bin/bash", "/usr/local/start.sh"]
