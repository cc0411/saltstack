zabbix-agent:
  pkg.installed:
    - name: zabbix22-agent
  file.managed:
    - name: /etc/zabbix_agentd.conf
    - source: salt://init/files/zabbix_agentd.conf
    - template: jinja
    - defaults:
      Zabbix_Server: {{ pillar['zabbix-agent']['Zabbix_Server'] }}
    - require:
      - pkg: zabbix-agent
  service.running:
    - name: zabbix-agentd
    - enable: True
    - watch:
      - file: zabbix-agent
