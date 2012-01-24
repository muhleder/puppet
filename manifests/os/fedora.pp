class fedora {
  yumrepo { "testing.com-repo":
    baseurl => "http://repos.testing.com/fedora/$lsbdistrelease/",
    descr => "Testing.com's YUM repository",
    enabled => 1,
    gpgcheck => 0,
  }
}