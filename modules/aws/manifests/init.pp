class aws {

  exec { 'aws-add-sources':
    unless => '/bin/grep "^deb http://ppa.launchpad.net/alestic/ppa/ubuntu lucid main" /etc/apt/sources.list',
    command => '/bin/echo "deb http://ppa.launchpad.net/alestic/ppa/ubuntu lucid main" >> /etc/apt/sources.list',
  }

  exec { 'aws-install-key':
    require => Exec['aws-add-sources'],
    command => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BE09C571',
  }

  exec { 'aws-update-sources':
    require => Exec['aws-install-key'],
    command => '/usr/bin/apt-get update',
  }

  package { 'ec2-consistent-snapshot':
    require => Exec['aws-update-sources'],
    ensure => 'installed',
  }

  exec { 'aws-setup-ec2-consistent-snapshot':
    require => Package['ec2-consistent-snapshot'],
    command => '/usr/bin/sudo PERL_MM_USE_DEFAULT=1 cpan Net::Amazon::EC2',
  }

  package { 'libdatetime-perl':
    ensure => 'installed',
  }

  package { 'libdatetime-format-dateparse-perl':
    ensure => 'installed',
  }

  file { '/usr/bin/ec2-prune-snapshots':
    owner => 'root',
    group => 'staff',
    mode => 744,
    replace => true,
    source => "puppet:///modules/aws/usr/bin/ec2-prune-snapshots",
  }

  file { '/home/ubuntu/serverbackup.sh':
    owner => 'root',
    group => 'staff',
    mode => 744,
    replace => false,
    source => "puppet:///modules/aws/home/ubuntu/serverbackup.sh",
  }

}

