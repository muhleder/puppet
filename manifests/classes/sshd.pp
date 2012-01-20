class sshd {
  case $operatingsystem {
    fedora: { $ssh_packages = ["openssh", "openssh-server", "openssh-clients"] }
    debian: { $ssh_packages = ["openssh-server", "openssh-client"] }
    ubuntu: { $ssh_packages = ["openssh-server", "openssh-client"] }
  }
  package { $ssh_packages: ensure => installed }

  service { sshd:
    name => $operatingsystem ? {
      fedora => "sshd",
      debian => "ssh",
      ubuntu => "ssh",
    },
    enable => true,
    ensure => running
  }
}