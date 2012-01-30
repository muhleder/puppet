class solr {

  package {'solr-jetty':
    ensure => present,
  }

  exec {'create-drupal-solr':
    require => Package['solr-jetty'],
    unless => '',
    command => 'cp -R /var/solr/example /var/solr/drupal'
  }

  file {'/var/solr/apache-solr/drupal/schema.xml':
    require => Exec['create-drupal-solr'],
    source => puppet:///modules/solr/var/solr/apache-solr/drupal/schema.xml
  }

  file {'/var/solr/apache-solr/drupal/solrconfig.xml':
    require => Exec['create-drupal-solr'],
    source => puppet:///modules/solr/var/solr/apache-solr/drupal/solrconfig.xml
  }

}