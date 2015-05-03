# Email Blackhole formula

Don’t bug people with your web app workbench email notification, catch ’em and read ’em locally!

**STATUS**: In progress

Will eventually follow [Salt Formulas *conventions*](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html).


## Usage

If you use Vagrant to develop, you can add this formula using the following syntax in your top file.

```yaml
# /srv/salt/top.sls
base:
  'biosversion:VirtualBox':
    - match: grain
    - emailblackhole
```

Be sure you require the state as an external GitFS and have similar `minion` config.

```yaml
# /etc/salt/minion.d/vagrant.conf
master: localhost
file_client: local

fileserver_backend:
  - roots
  - git

gitfs_remotes:
  - https://github.com/renoirb/emailblackhole-formula.git
```

Emails won’t go out, but to prevent bouncing you can adjust `emailblackhole:dc_other_hostnames` with the list of email providers you want to superseed locally.



## Features

The following assumes you would run this state as part of a [Vagrant *local* development](https://www.vagrantup.com/) setup.

Access your workspace VM through SSH

    vagrant ssh


Then...


### Test email delivery


Try sending yourself an email using `swaks`

    swaks -t bogus@localhost -s localhost

Look where the mail went:

    sudo tail -f /var/log/exim4/mainlog
    2015-04-26 22:07:54 1YmUiQ-0006bB-Pn <= vagrant@sweetiesweetie.local H=localhost (sweetiesweetie.local) [127.0.0.1] P=esmtp S=498
    2015-04-26 22:07:54 1YmUiQ-0006bB-Pn => vagrant <bogus@localhost> R=local_user T=maildir_home
    2015-04-26 22:07:54 1YmUiQ-0006bB-Pn Completed

Exit tail with <kbd>ctrl</kbd>+<kbd>c</kbd>

Read the email locally using `mutt`. You should see it;

    mutt

![emailblackhole-local-mutt](https://cloud.githubusercontent.com/assets/296940/7446280/54b6e112-f1a1-11e4-9cd7-eed758c8f301.png)

#### Mutt in a nutshell

* <kbd>ENTER</kbd> to confirm, or read
* <kbd>q</kbd> to quit
* <kbd>d</kbd> to delete

Rest are instructions shown in the UI.



# Reference

This work was based on notes gathered around, here are the most helpful pages I found.

* http://www.courier-mta.org/maildrop/
* https://github.com/Exim/exim/wiki/EximSecurity
* http://www.exim.org/exim-html-current/doc/html/spec_html/ch-address_rewriting.html
* http://www.exim.org/exim-html-current/doc/html/spec_html/ch-security_considerations.html
* http://www.exim.org/exim-html-current/doc/html/spec_html/ch-the_exim_run_time_configuration_file.html
* https://lists.debian.org/debian-user/2004/10/msg01701.html
* https://www.rosehosting.com/blog/how-to-setup-a-mailserver-with-exim4-and-dbmail-on-a-debian-7-vps/
* http://stackoverflow.com/questions/2417306/catchall-router-on-exim-does-not-work

