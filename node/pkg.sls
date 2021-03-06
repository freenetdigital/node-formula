{%- from "node/map.jinja" import node, npm_bin with context %}

{%- if grains['os_family'] in ['Ubuntu', 'Debian'] and salt['pillar.get']('node:install_from_ppa') %}
nodejs.ppa:
  pkg.installed:
    - name: apt-transport-https
    - require_in:
      - pkgrepo: nodejs.ppa
  pkgrepo.managed:
    - humanname: NodeSource Node.js Repository
    - name: deb {{ salt['pillar.get']('node:ppa:repository_url', 'https://deb.nodesource.com/node_6.x') }} {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/nodesource.list
    - key_url: {{ salt['pillar.get']('node:ppa:custom_repo_gpgkey', 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key') }}
  {%- if salt['pillar.get']('node:ppa:custom_repo_gpgkey') is not defined %}
    - keyid: "68576280"
    - keyserver: keyserver.ubuntu.com
  {%- endif %}
    - require_in:
      - pkg: nodejs
{%- endif %}
nodejs:
  pkg.installed:
    - name: {{ node.node_pkg }}
    - reload_modules: true
{%- if salt['pillar.get']('node:version') %}
    - version: {{ salt['pillar.get']('node:version') }}
    - hold: True
{%- endif %}
