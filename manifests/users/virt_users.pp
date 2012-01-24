class virt_users {
  @user { "ubuntu":
    ensure => "present",
    comment => "Ubuntu User",
    home => "/home/ubuntu",
    shell => "/bin/bash",
  }
}