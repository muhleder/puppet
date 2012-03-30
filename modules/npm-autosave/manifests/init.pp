class npm-autosave {
  require chris::lea::nodejs

  exec {'install-autosave':
    command => '/usr/bin/npm -g install autosave',
    unless => '/usr/bin/npm -g list | grep autosave',
  }

  exec {'/usr/bin/autosave --config /etc/npm-autosave/routes.js':
    require => [
      Exec['install-autosave'],
      File['/etc/npm-autosave/routes.js']
    ]
  }

  file {'/etc/npm-autosave':
    ensure => directory,
  }

  file {'/etc/npm-autosave/routes.js':
    require => File['/etc/npm-autosave'],
    source => 'puppet:///modules/npm-autosave/etc/npm-autosave/routes.js',
  }

}