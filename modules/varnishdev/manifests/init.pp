class varnishdev {

  aptkey { "varnish":
    ensure => present,
    apt_key_url => 'http://repo.varnish-cache.org/debian/GPG-key.txt',
  }

  exec { 'varnish-add-sources':
    unless => '/bin/grep "^deb http://repo.varnish-cache.org/ubuntu/ $(lsb_release -s -c)" /etc/apt/sources.list',
    command => '/bin/echo "deb http://repo.varnish-cache.org/ubuntu/ $(lsb_release -s -c) varnish-2.1" >> /etc/apt/sources.list',
    require => Aptkey['varnish'],
  }

  package { 'varnish' :
    require => [
      File['/etc/varnish/default.vcl'],
      File['/etc/default/varnish'],
      Exec['varnish-add-sources'],
    ],
    ensure => 'installed',
  }

  service { varnish:
    require => [
      Package['varnish'],
    ],
    enable => "true",
    ensure => "running",
  }

  file { '/etc/varnish':
    owner => "root",
    group => "staff",
    replace => false,
    recurse => false,
    ensure => directory,
  }

  file { '/etc/varnish/default.vcl':
    owner => "root",
    group => "staff",
    mode => 664,
    replace => true,
    require => File['/etc/varnish'],
    source => "puppet:///modules/varnishdev/etc/varnish/default.vcl",
  }

  file { '/etc/default/varnish':
    owner => "root",
    group => "staff",
    mode => 664,
    replace => true,
    source => "puppet:///modules/varnishdev/etc/default/varnish",
  }
}
