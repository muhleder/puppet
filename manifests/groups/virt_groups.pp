class virt_groups {
  @group { "staff":
    ensure => present
  }
  @group { "administration":
    ensure => present
  }
  @group { "puppet":
   ensure => present
  }
}