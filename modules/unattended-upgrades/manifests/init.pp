class unattended-upgrades {

  package {'unattended-upgrades':
    ensure => installed,
  }

  file {'/etc/apt/apt.conf.d/50unattended-upgrades':
    source => "puppet:///modules/unattended-upgrades/etc/apt/apt.conf.d/50unattended-upgrades",
  }

  file {'/etc/apt/apt.conf.d/10periodic':
    source => "puppet:///modules/unattended-upgrades/etc/apt/apt.conf.d/10periodic",
  }

}