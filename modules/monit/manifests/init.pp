class monit {

  $packagelist = ["monit"]

  package { $packagelist:
  ensure => installed }

  file { "/etc/monit/monitrc":
    owner => "root",
    group => "root",
    mode => "0600",
    replace => true,
    source => "puppet:///modules/monit/etc/monit/monitrc",
    require => Package["monit"],
  }

  file {"/etc/monit/monitrc.d":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 700,
    require => Package["monit"],
  }

  # Need to set startup=1 in /etc/default/monit
  file {"/etc/default/monit":
    owner  => root,
    group  => root,
    mode   => 700,
    source => "puppet:///modules/monit/etc/default/monit",
  }

  service { monit:
    enable => "true",
    ensure => "running",
    require => File["/etc/monit/monitrc"]
  }

}