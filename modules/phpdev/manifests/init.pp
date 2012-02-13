
class phpdev {

  $packagelist = ['php5-dev', 'php-pear', 'graphviz']

  package { $packagelist: ensure => installed }

  exec {'/usr/bin/pecl install xdebug-2.1.0':
    require => Package[$packagelist],
    unless => '/usr/bin/locate xdebug | grep xdebug',
  }

  exec {'/usr/bin/pecl install xhprof-0.9.2':
    require => Package[$packagelist]
  }

  exec {'/usr/bin/pear upgrade pear':

  }

  exec {'/usr/bin/git clone https://github.com/facebook/xhprof.git /var/xhprof':
    unless => '/usr/bin/test -d /var/xhprof',
  }

  file {'/etc/php5/apache2/conf.d/phpdev.ini':
    source => 'puppet:///modules/phpdev/etc/php5/apache2/conf.d/phpdev.ini',
  }

  file {'/etc/apache2/sites-enabled/xhprof':
    source => 'puppet:///modules/phpdev/etc/apache2/sites-enabled/xhprof',
  }

  file {'/etc/php5/apache2/conf.d/xdebug.ini':
    source => 'puppet:///modules/phpdev/etc/php5/apache2/conf.d/xdebug.ini',
  }

}