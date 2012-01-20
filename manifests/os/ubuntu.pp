class ubuntu {
  $disableservices = ["hplip", "avahi-daemon", "rsync", "spamassassin"]
  service { $disableservices:
    enable => false,
    ensure => stopped,
  }
}