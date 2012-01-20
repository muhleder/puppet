class baseapps {

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  $packagelist = ["nano", "git-core", "unzip"]

  package { $packagelist:
    ensure => installed
  }

  exec { '/usr/sbin/locale-gen en_US en_US.UTF-8':
    unless => '/usr/bin/locale | grep LANG=en_US',
  }

}