class staff {
  include virt_users, virt_groups
  realize(
    Group["puppet"],
  )

}