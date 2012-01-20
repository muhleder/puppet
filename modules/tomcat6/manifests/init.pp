class tomcat6 {

  package { 'tomcat6':
    ensure => installed
  }

  package { 'gij-4.3':
    ensure => installed
  }


  user { tomcat6:
    ensure => present,
  }

  file { "/var/tomcat6/conf":
    owner => "root",
    group => "administration",
    mode => 774,
    replace => true,
    recurse => true,
    source => "puppet:///modules/tomcat6/var/tomcat6/conf",
  }

  $system_dirs = [
    "/usr/lib",
    "/usr/lib/jvm",
    "/usr/lib/jvm/java-6-openjdk",
    "/usr/lib/jvm/java-6-openjdk/jre",
    "/usr/lib/jvm/java-6-openjdk/jre/lib",
    "/usr/lib/jvm/java-6-openjdk/jre/lib/security",
    "/var/tomcat6",
    "/var/tomcat6/temp",
    "/var/tomcat6/conf/Catalina",
    "/var/tomcat6/conf/Catalina/localhost",
  ]

  $tomcat_dirs = [
    "/var/tomcat6/logs",
    "/var/tomcat6/certs",
    "/var/tomcat6/webapps",
    "/var/tomcat6/work",
    "/var/apps",
    "/var/homes",
  ]

  file { $system_dirs:
    owner => "root",
    group => "administration",
    mode => 774,
    ensure => directory,
  }

  file { $tomcat_dirs:
    owner => "tomcat6",
    group => "administration",
    mode => 774,
    ensure => directory,
  }

  file { "/var/tomcat6/bin":
    owner => "root",
    group => "administration",
    mode => 774,
    ensure => directory,
  }

  file { "/var/tomcat6/bin/setenv.sh":
    owner => "root",
    group => "administration",
    mode => 774,
    replace => true,
    source => "puppet:///modules/tomcat6/var/tomcat6/bin/setenv.sh",
  }

  # Set CATALINA_BASE to be /var/tomcat6
  file { "/etc/default/tomcat6":
    owner => "root",
    group => "administration",
    mode => 774,
    replace => true,
    source => "puppet:///modules/tomcat6/etc/default/tomcat6",
  }

  service { tomcat6:
    enable => "true",
    require => [
      Exec['gmail-cert'],
      Package['gij-4.3'],
      Package['tomcat6'],
      File['/var/tomcat6/bin/setenv.sh'],
     ],
    ensure => "running",
  }

  file { "/var/tomcat6/certs/gmail.cert":
    owner => "root",
    group => "administration",
    mode => 774,
    replace => true,
    source => "puppet:///modules/tomcat6/var/tomcat6/certs/gmail.cert",
  }

  exec { "gmail-cert":
    unless => "/usr/bin/keytool -list  -keystore /usr/lib/jvm/java-6-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt | grep smtp.gmail.com",
    require => [
      Package['gij-4.3'],
      Package['tomcat6'],
      File['/var/tomcat6/certs/gmail.cert'],
      File['/usr/lib/jvm/java-6-openjdk/jre/lib/security'],
    ],
    command => "/usr/bin/keytool -v -import -alias smtp.gmail.com -keystore /usr/lib/jvm/java-6-openjdk/jre/lib/security/cacerts -file /var/tomcat6/certs/gmail.cert -storepass changeit -noprompt",
  }

}