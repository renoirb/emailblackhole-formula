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


## Features

The following assumes you would run this state as part of a [Vagrant *local* development](https://www.vagrantup.com/) setup.

Access your workspace VM through SSH

    vagrant ssh


Then...


### Test email delivery


Try sending yourself an email using `swaks`

    swaks -t bogus@localhost -s localhost

Open up `mutt` and see if you got it.

    mutt

#### Mutt in a nutshell

* <kbd>ENTER</kbd> to confirm, or read
* <kbd>q</kbd> to quit
* <kbd>d</kbd> to delete

Rest are instructions shown in the UI.

