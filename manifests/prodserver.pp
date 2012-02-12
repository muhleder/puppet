import "setup.pp"

node default {
  include baseclass
  include monitor
  include apache2
  include varnish
  include mysql
  include aws
  include drupalapps
  include unattended-upgrades
}