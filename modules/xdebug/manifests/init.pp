class xdebug {
  #TODO tidy this up so only run once

  $packagelist = ['php5-dev', 'php-pear']

  package { $packagelist: ensure => installed }

  exec {'/usr/bin/pecl install xdebug-2.1.0':
    require => Package[$packagelist]
  }

}