
class phpdev {

  file {'/etc/php5/apache2/conf.d/phpdev.ini':
    source => 'puppet:///modules/phpdev/etc/php5/apache2/conf.d/phpdev.ini',
  }

}