base:
  '*':
    - init.env_init

prod:
  '*':
    - cluster.haproxy-outside
