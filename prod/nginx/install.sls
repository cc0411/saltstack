include:
  - init.install
  - pcre.install

nginx-source-install:
  file.managed:
    - name: /usr/local/src/nginx-1.9.1.tar.gz
    - source: salt://nginx/files/nginx-1.9.1.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar zxf nginx-1.9.1.tar.gz && cd nginx-1.9.1 && ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-file-aio --with-http_dav_module --with-pcre=/usr/local/src/pcre-8.37 && make && make install
    - unless: test -d /usr/local/nginx
    - require: 
      - file: nginx-source-install
      - pkg: pkg-init
      - cmd: pcre-source-install

nginx-init:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://nginx/files/nginx-init
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add nginx
    - unless: chkconfig --list | grep nginx
    - require:
      - file: nginx-init

/usr/local/nginx/conf/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf
    - user: root
    - group: root
    - mode: 644

nginx-service:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - require: 
      - cmd: nginx-source-install
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - cmd: nginx-init
    - watch:
      - file: /usr/local/nginx/conf/nginx.conf
