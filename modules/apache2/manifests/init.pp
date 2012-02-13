class apache2 {
  
  $apache2_sites = "/etc/apache2/sites"
  $apache2_mods = "/etc/apache2/mods"
  
  $packagelist = ["apache2", "php5", "php-apc", "php5-gd", 'php5-mysql', 'php5-cli', 'php5-curl']
  
  $modsenable = ["alias", "auth_basic", "authz_host", "deflate", "dir", "expires",	"headers", "mime", "php5", "rewrite"]
	$modsdisable = ["authz_default", "cgid", "cgi", "negotiation",	"reqtimeout", "setenvif", "status"]

  package { $packagelist: ensure => installed }

  apache2::module { $modsenable:
    ensure=> present,
    require => Service['apache2'],
  }
  apache2::module { $modsdisable:
    ensure=> absent,
    require => Service['apache2'],
  }


  $apache_conf_dir = "/etc/apache2"
  $php_conf_dir = "/etc/php5"
  $group = "administration"
  $webuser = "www-data"
  $user = "ubuntu"


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

  file { "/var/www/docroot":
    owner => "$user",
    group => $group,
    mode => 774,
    replace => false,
    recurse => false,
    ensure => directory,
  }

  file { "$apache_conf_dir/sites-available/default":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/apache2/etc/apache2/sites-enabled/default",
  }

  file { "$apache_conf_dir/apache2.conf":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/apache2/etc/apache2/apache2.conf",
  }

  file { "/etc/php5/apache2/conf.d/custom.ini":
    source => "puppet:///modules/apache2/etc/php5/apache2/conf.d/custom.ini",
  }

  file { "$apache_conf_dir/ports.conf":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/apache2/etc/apache2/ports.conf",
  }

  # Define an apache2 module. Debian packages place the module config
  # into /etc/apache2/mods-available.
  define module ( $ensure = 'present', $require = 'apache2' ) {
    case $ensure {
      'present' : {
        exec { "/usr/sbin/a2enmod $name":
         unless => "/bin/readlink -e ${apache2_mods}-enabled/${name}.load",
         notify => Exec["force-reload-apache2"],
        }
      }
      'absent': {
        exec { "/usr/sbin/a2dismod $name":
         onlyif => "/bin/readlink -e ${apache2_mods}-enabled/${name}.load",
         notify => Exec["force-reload-apache2"],
        }
      }
      default: { err ( "Unknown ensure value: '$ensure'" ) }
    }
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

  service { apache2:
    require => [

      Package['php5'],
      Package['php-apc'],
      Package['php5-gd'],
    ],
    enable => "true",
    ensure => "running",
  }



  group { $webuser:
    gid => 33,
    ensure => present
  }

  group { 'ubuntu':
    ensure => present,
  }

  user { 'www-data':
    require => Group['ubuntu'],
    groups => ['www-data', 'ubuntu'],
  }


}