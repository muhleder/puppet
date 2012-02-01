class xdebug {

  $packagelist = ['php5-dev', 'php-pear']

  package { $packagelist: ensure => installed }

  exec {'pecl install xdebug-2.1.0':
    require => Package[$packagelist]
  }

}