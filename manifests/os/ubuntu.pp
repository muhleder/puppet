class ubuntu {
  $disableservices = ["rsync"]
  service { $disableservices:
    enable => false,
    ensure => stopped,
  }
}