# TODO Remove test user.
# TODO Limit access to localhost for security.
# TODO Ask for and set root password at boot.

class mysql {

  $packagelist = ["mysql-server"]

  package { $packagelist:
  ensure => installed }

  file { "/etc/my.cnf":
    owner => "root",
    group => "root",
    mode => "0644",
    replace => true,
    source => "puppet:///modules/mysql/my.cnf",
  }

  service { mysql:
    enable => "true",
    ensure => "running",
    require => [
      File["/etc/my.cnf"],
      Package["mysql-server"]
    ],
    subscribe => File['/etc/my.cnf'],
  }

}








