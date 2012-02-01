class solr {

  package {'solr-jetty':
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

  service {'jetty':
    require => File['/etc/default/jetty'],
    ensure => running,
  }

}