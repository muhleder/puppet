class varnishdev {

  package { 'varnish' :
    require => [
      File['/etc/varnish/default.vcl'],
      File['/etc/default/varnish'],
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
