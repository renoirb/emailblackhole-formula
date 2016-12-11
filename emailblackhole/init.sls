{%- set development_username = salt['pillar.get']('emailblackhole:username', 'ubuntu') %}

formula-shell-utils:
  pkg.installed:
    - pkgs:
      - mutt
      - swaks

exim4:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: Email catch_all blackhole

/usr/sbin/update-exim4.conf:
  cmd.wait:
    - user: root
    - group: root
    - require:
      - service: exim4

Email catch_all blackhole:
  pkg.installed:
    - pkgs:
      - exim4-daemon-light
      - maildrop
  file.managed:
    - name: /etc/exim4/update-exim4.conf.conf
    - source: salt://emailblackhole/files/update-exim4.conf.jinja
    - template: jinja
    - context:
        development_username: {{ development_username }}
        dc_other_hostnames: {{ salt['pillar.get']('emailblackhole:dc_other_hostnames', []) }}
  cmd.run:
    - name: maildirmake /home/{{ development_username }}/Maildir
    - user: {{ development_username }}
    - group: {{ development_username }}
    - unless: test -d /home/{{ development_username }}/Maildir
    - listen_in:
      - service: exim4

/etc/exim4/conf.d/router/950_exim4-config_catchall:
  file.managed:
    - source: salt://emailblackhole/files/exim4-config.catch_all
  cmd.run:
    - name: /usr/sbin/update-exim4.conf.template -r
    - listen_in:
      - service: exim4

/etc/aliases:
  file.managed:
    - source: salt://emailblackhole/files/alias.jinja
    - template: jinja
    - context:
        development_username: {{ development_username }}
    - listen_in:
      - service: exim4

/home/{{ development_username }}/.muttrc:
  file.managed:
    - source: salt://emailblackhole/files/muttrc.jinja
    - template: jinja
    - context:
        development_username: {{ development_username }}
    - require:
      - pkg: formula-shell-utils
