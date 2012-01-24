import "templates.pp"
import "classes/*"
import "groups/*"
import "users/*"
import "os/*"



filebucket { main: server => puppet }
File { backup => main }

define aptkey($ensure, $apt_key_url = "http://www.example.com/apt/keys") {
  case $ensure {
    "present": {
      exec { "apt-key present $name":
              command => "/usr/bin/wget -q $apt_key_url -O -|/usr/bin/apt-key add -",
              unless => "/usr/bin/apt-key list|/bin/grep -c $name",
      }
    }
    "absent": {
      exec { "apt-key absent $name":
              command => "/usr/bin/apt-key del $name",
              onlyif => "/usr/bin/apt-key list|/bin/grep -c $name",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}


