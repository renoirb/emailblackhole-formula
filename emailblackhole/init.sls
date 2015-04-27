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
        dc_other_hostnames: {{ salt['pillar.get']('emailblackhole:dc_other_hostnames', []) }}
  cmd.run:
    - name: maildirmake /home/vagrant/Maildir
    - user: vagrant
    - group: vagrant
    - unless: test -d /home/vagrant/Maildir
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
    - listen_in:
      - service: exim4

/home/vagrant/.muttrc:
  file.managed:
    - source: salt://emailblackhole/files/muttrc.jinja
    - template: jinja
    - require:
      - pkg: formula-shell-utils

