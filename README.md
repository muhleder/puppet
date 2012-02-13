# Analog puppet configs

A set of puppet manifests and modules to install various server stacks

* Drupal oriented
* Built for Ubuntu Lucid
* Development server includes xdebug and xhprof for debugging and profiling
* Production servers are set up to save automated snapshots to EC2, 1 daily 1 weekly


## Usage

### Instalation

Run init.sh as root to install git, puppet and clone this repository to /var/puppet.

### Application

Run any of the following commands to install a server stack.

#### A php mysql development server tuned for Drupal
    puppet -v /var/puppet/manifests/devserver.pp

#### A php mysql development server tuned for Drupal with a jetty solr installation
    puppet -v /var/puppet/manifests/devserver_solr.pp

#### A php mysql production server tuned for Drupal
    puppet -v /var/puppet/manifests/prodserver.pp

#### Run this against your production server to see what changes would be applied
    puppet -v --noop /var/puppet/manifests/prodserver.pp

#### A jenkins CI server
    puppet -v /var/puppet/manifests/jenkins.pp

#### A Solr server running under Jetty
    puppet -v /var/puppet/manifests/solr.pp


## Important notes

* There is no firewall included, firewall is intended to be provided by the AWS security groups.
* The production server includes automated security upgrades.
* Sensitive system data is expected to be manually set as environment variables in /etc/environment
  Eg. from the monit module here we have

        set mailserver $SMTP_MAILSERVER port $SMTP_MAILSERVER_PORT USERNAME $SMTP_MAILSERVER_USER PASSWORD $SMTP_MAILSERVER_PASS using tlsv1

  Monit and AWS modules look for your account data in this way.