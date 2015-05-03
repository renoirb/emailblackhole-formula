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

    vagrant@sweetiesweetie:~$ swaks -t bogus@gmail.com -s localhost --body 'Hey let me send this to gmail.com'
    === Trying localhost:25...
    === Connected to localhost.
    <-  220 sweetiesweetie ESMTP Exim 4.82 Ubuntu Sun, 03 May 2015 18:38:41 +0000
     -> EHLO sweetiesweetie.local
    <-  250-sweetiesweetie Hello localhost [127.0.0.1]
    <-  250-SIZE 52428800
    <-  250-8BITMIME
    <-  250-PIPELINING
    <-  250 HELP
     -> MAIL FROM:<vagrant@sweetiesweetie.local>
    <-  250 OK
     -> RCPT TO:<bogus@gmail.com>
    <-  250 Accepted
     -> DATA
    <-  354 Enter message, ending with "." on a line by itself
     -> Date: Sun, 03 May 2015 18:38:41 +0000
     -> To: bogus@gmail.com
     -> From: vagrant@sweetiesweetie.local
     -> Subject: test Sun, 03 May 2015 18:38:41 +0000
     -> X-Mailer: swaks v20130209.0 jetmore.org/john/code/swaks/
     ->
     -> Hey let me send this to gmail.com
     ->
     -> .
    <-  250 OK id=1Yoymn-0000iN-E1
     -> QUIT
    <-  221 sweetiesweetie closing connection
    === Connection closed with remote host.

Look where the mail went:

    sudo tail /var/log/exim4/mainlog
    2015-05-03 18:38:41 1Yoymn-0000iN-E1 <= vagrant@sweetiesweetie.local H=localhost (sweetiesweetie.local) [127.0.0.1] P=esmtp S=509
    2015-05-03 18:38:41 1Yoymn-0000iN-E1 => vagrant <bogus@gmail.com> R=local_user T=maildir_home
    2015-05-03 18:38:41 1Yoymn-0000iN-E1 Completed

Exit tail with <kbd>ctrl</kbd>+<kbd>c</kbd>

Read the email locally using `mutt`. You should see it;

    mutt

![emailblackhole-local-mutt](https://cloud.githubusercontent.com/assets/296940/7446329/a11e6eac-f1a2-11e4-83b1-a6c01dd54b1a.png)


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

