include:
  - nginx.install
  - php.install

web-bbs:
  file.managed:
    - name: /usr/local/nginx/conf/vhost/test.conf
    - source: salt://bbs/files/test.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - service: php-fastcgi-service
    - watch_in:
      - service: nginx-service
