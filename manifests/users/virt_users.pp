class virt_users {
  @user { "vagrant":
    ensure => "present",
    comment => "Ubuntu User",
    home => "/home/ubuntu",
    shell => "/bin/bash",
  }
}