/*

== Class: varnish

Installs the varnish http accelerator and stops the varnishd and varnishlog
services, because they are handled separately by varnish::instance.

*/
class varnish {

  package { "varnish": ensure => present }

  service { "varnish":
    enable  => true,
    ensure  => "running",
  }

  service { "varnishlog":
    enable  => false,
    ensure  => "stopped",
  }

  file { "/usr/local/sbin/vcl-reload.sh":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => "0755",
    source => "puppet:///modules/varnish/usr/local/sbin/vcl-reload.sh",
  }

  file { "/etc/default/varnish":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => "0755",
    source => "puppet:///modules/varnish/etc/default/varnish",
  }

  file { "/etc/varnish":
    mode => 774,
    ensure => directory,
    owner  => "root",
    group  => "staff",
  }

  file { "/etc/varnish/default.vcl":
    ensure => present,
    owner  => "root",
    group  => "staff",
    mode   => "0755",
    require => File['/etc/varnish'],
    source => "puppet:///modules/varnish/etc/varnish/default.vcl",
  }

}
