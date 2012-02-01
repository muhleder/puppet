
class phpdev {

  file {'/etc/php5/apache2/conf.d/phpdev.ini':
    source => 'puppet:///files/phpdev/etc/php5/apache2/conf.d/phpdev.ini',
  }

}