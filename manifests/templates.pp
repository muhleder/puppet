class baseclass {
  case $operatingsystem {
    fedora: { include fedora }
    debian: { include debian }
    ubuntu: { include ubuntu }
  }
  include baseapps, sshd, staff
}

class drupalapps {
  include drush
}

class monitor {
  include monit
}

class mailserver {
  include postfix
}
