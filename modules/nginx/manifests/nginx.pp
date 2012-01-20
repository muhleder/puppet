class nginx {
  $packagelist = ["nginx", "php5-fpm", "php5-cgi", "php5-apc", "php5-gd"]

  package { $packagelist: ensure => installed }

  case $operatingsystem {
    Darwin: {
        $nginx_conf_dir = "/opt/local/etc/nginx"
        $php_conf_dir = "/opt/local/etc/php5"
        $group = "staff"
        $webuser = "_www"
    }
    fedora: {
        $nginx_conf_dir = "/etc/nginx"
        $php_conf_dir = "/etc/php5"
        $group = "administration"
        $webuser = "www-data"
    }
    debian: {
        $nginx_conf_dir = "/etc/nginx"
        $php_conf_dir = "/etc/php5"
        $group = "administration"
        $webuser = "www-data"
    }
    ubuntu: {
        $nginx_conf_dir = "/etc/nginx"
        $php_conf_dir = "/etc/php5"
        $group = "administration"
        $webuser = "www-data"
    }
  }

  file { $nginx_conf_dir:
    owner => "root",
    group => $group,
    mode => 754,
    replace => false,
    recurse => false,
    ensure => directory,
  }

  file { "/var/www":
    owner => "$webuser",
    group => $group,
    mode => 774,
    replace => false,
    recurse => false,
    ensure => directory,
  }

  file { "/var/www/nginx-default/index.html":
    owner => "$webuser",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/var/www/nginx-default/index.html",
  }

  file { "${nginx_conf_dir}/drupal.conf":
    owner => "$webuser",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/nginx/drupal.conf",
  }

  file { "${nginx_conf_dir}/sites-available/default":
    owner => "$webuser",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/nginx/sites-enabled/default",
  }

  file { "${nginx_conf_dir}/nginx.conf":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/nginx/nginx.conf",
  }

  file { "${nginx_conf_dir}/mime.types":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/nginx/mime.types",
  }

  file { "/usr/sbin/nxensite":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/nxensite",
  }

  file { "/usr/sbin/nxdissite":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/nxdissite",
  }

  file { "/etc/bash_completion.d/nginx-ensite":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/nginx-ensite",
  }

  file { "${php_conf_dir}/cli/php.ini":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/php5/cli/php.ini",
  }

  file { "${php_conf_dir}/fpm/php.ini":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/php5/fpm/php.ini",
  }

  file { "${php_conf_dir}/fpm/php-fpm.conf":
    owner => "root",
    group => $group,
    mode => 754,
    replace => true,
    source => "puppet:///modules/nginx/etc/php5/fpm/php-fpm.conf",
  }

  file { "/var/log/php-fpm":
    owner => "$webuser",
    group => $group,
    mode => 774,
    replace => false,
    recurse => false,
    ensure => directory,
  }

  service { nginx:
    enable => "true",
    ensure => "running",
  }

  service { php5-fpm:
    enable => "true",
    ensure => "running",
  }



  group { $webuser:
    gid => 33,
    ensure => present
  }


}