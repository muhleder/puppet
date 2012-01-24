class jenkins {

  file { "/etc/apt/sources.list.d/jenkins.list":
    owner => "root",
    group => "staff",
    mode => 754,
    replace => true,
    source => "puppet:///modules/jenkins/etc/apt/sources.list.d/jenkins.list",
  }

  aptkey { "jenkins":
    ensure => present,
    apt_key_url => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
  }

  exec { 'jenkins-update-sources':
    require => [
      File['/etc/apt/sources.list.d/jenkins.list'],
      Aptkey['jenkins'],
    ],
    command => '/usr/bin/apt-get update',
  }

  package { 'jenkins':
    require => Exec['jenkins-update-sources'],
    ensure => 'installed',
  }


}

