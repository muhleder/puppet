class webistrano {

  $user = "ubuntu"
  $group = "staff"

  $packagelist = ["ruby", "mysql", "rake"]

  package { $packagelist: ensure => installed }


  file { $apache_conf_dir:
    owner => "root",
    group => $group,
    mode => 754,
    replace => false,
    recurse => false,
    ensure => directory,
  }

  file { "/var/www":
    owner => "$user",
    group => $group,
    mode => 774,
    replace => false,
    recurse => false,
    ensure => directory,
  }

  file { "/var/www/webistrano":
    owner => "$user",
    group => $group,
    mode => 774,
    replace => false,
    recurse => true,
    source => "puppet:///modules/webistrano/var/www/webistrano",
  }


  # Notify this when apache needs a reload. This is only needed when
  # sites are added or removed, since a full restart then would be
  # a waste of time. When the module-config changes, a force-reload is
  # needed.
  exec { "reload-apache2":
    command => "/etc/init.d/apache2 reload",
    refreshonly => true,
  }

  exec { "force-reload-apache2":
    command => "/etc/init.d/apache2 force-reload",
    refreshonly => true,
  }


}