#!/bin/bash

echo "Choose a package to install"
echo "Production Webserver[1]"
echo "Development Webserver[2]"
echo "Jira[3]"
echo "Confluence[4]"
read opt

case $opt in
  [1] )
    echo "Installing production webserver stack"
    puppet -v /var/puppet/manifests/prodserver.pp
    ;;
  [2] )
    echo "Installing dev webserver stack"
    puppet -v /var/puppet/manifests/devserver.pp
    ;;
  *)
    echo "Invalid input"
    ;;
esac