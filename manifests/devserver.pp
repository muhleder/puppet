import "setup.pp"

node default {
  include baseclass
  include apache2
  include varnishdev
  include mysql
  include drupalapps
  include phpdev
  include xdebug
}