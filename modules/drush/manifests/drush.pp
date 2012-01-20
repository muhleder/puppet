class drush {

  file { "/usr/share/drush":
    owner => "ubuntu",
    group => "staff",
    mode => 754,
    replace => true,
    recurse => true,
    source => "puppet:///modules/drush/usr/share/drush",
  }

  file { "/usr/bin/drush":
    ensure => link,
    target => "/usr/share/drush/drush",
  }

}

