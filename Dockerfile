FROM debian:stretch

MAINTAINER Vladimir Bulyga <zero@13w.me>

RUN apt update && \
    apt install -y curl tar gcc libpcre3-dev zlib1g-dev make libssl-dev libluajit-5.1-dev && \
    cd /tmp && \
    curl -L http://nginx.org/download/nginx-1.15.1.tar.gz -o nginx.tar.gz && \
    curl -L https://github.com/simpl/ngx_devel_kit/archive/master.tar.gz -o ngx_devel_kit.tar.gz && \
    curl -L https://github.com/openresty/set-misc-nginx-module/archive/master.tar.gz -o set-misc-nginx-module.tar.gz && \
    curl -L https://github.com/openresty/lua-nginx-module/archive/master.tar.gz -o lua-nginx-module.tar.gz && \
    mkdir nginx ngx_devel_kit set-misc-nginx-module lua-nginx-module && \
    tar xf nginx.tar.gz -C nginx --strip-components=1 && \
    tar xf ngx_devel_kit.tar.gz -C ngx_devel_kit --strip-components=1 && \
    tar xf set-misc-nginx-module.tar.gz -C set-misc-nginx-module --strip-components=1 && \
    tar xf lua-nginx-module.tar.gz -C lua-nginx-module --strip-components=1 && \
    cd nginx && \
    ./configure --prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--modules-path=/usr/lib/nginx/modules \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--http-client-body-temp-path=/var/cache/nginx/client_temp \
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
	--user=nginx \
	--group=nginx \
	--with-compat \
	--with-file-aio \
	--with-threads \
	--with-http_addition_module \
	--with-http_auth_request_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_mp4_module \
	--with-http_random_index_module \
	--with-http_realip_module \
	--with-http_secure_link_module \
	--with-http_slice_module \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_sub_module \
	--with-http_v2_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-stream \
	--with-stream_realip_module \
	--with-stream_ssl_module \
	--with-stream_ssl_preread_module \
	--add-module=../lua-nginx-module \
	--add-module=../ngx_devel_kit \
	--add-module=../set-misc-nginx-module && \
    make && \
    make install && \
    apt-mark manual libluajit-5.1-2 libluajit-5.1-common libssl1.1 && \
    apt remove -y curl gcc libpcre3-dev zlib1g-dev make libssl-dev libluajit-5.1-dev && \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /tmp/* && \
    adduser --system --no-create-home --disabled-login --group --system nginx && \
    mkdir /var/cache/nginx && \
    chown nginx:nginx /var/cache/nginx

CMD ["nginx", "-g", "daemon off;"]

