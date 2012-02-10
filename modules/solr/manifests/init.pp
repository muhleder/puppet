class solr {

  package {'openjdk-6-jdk':
    ensure => present,
  }

  package {'solr-jetty':
    require => Package['openjdk-6-jdk'],
    ensure => present,
  }

  file {'/usr/share/solr/conf/schema.xml':
    require => Package['solr-jetty'],
    source => 'puppet:///modules/solr/usr/share/solr/conf/schema.xml',
  }

  file {'/usr/share/solr/conf/solrconfig.xml':
    require => Package['solr-jetty'],
    source => 'puppet:///modules/solr/usr/share/solr/conf/solrconfig.xml',
  }

  file {'/etc/default/jetty':
    require => Package['solr-jetty'],
    source => 'puppet:///modules/solr/etc/default/jetty',
  }

  file {'/etc/init.d/solr':
    source => 'puppet:///modules/solr/etc/init.d/solr',
    mode => 744,
  }

  file {'/usr/share/solr':
    ensure => directory,
    owner => jetty,
  }

  file {'/usr/share/solr/data':
    require => File['/usr/share/solr'],
    ensure => directory,
    owner => jetty,
  }

  service {'jetty':
    require => File[
      '/usr/share/solr/data',
      '/etc/default/jetty'
    ],
    subscribe => File['/usr/share/solr/data'],
    ensure => running,
  }

}