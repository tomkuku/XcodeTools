#!/bin/bash

should_install_pods=0
should_update_pods=0
should_clear_derived_data=0

while getopts ":puc" option ; do
  case "$option" in
  'p') # install pods
    should_install_pods=1
    ;;
  'u') # update pods
    should_update_repo=1
    ;;
  'c') # clear drived data
    should_clear_derived_data=1
    ;;
  *)
    echo "Invalid options!"
    exit -1
    ;;
  esac
done

echo "should_install_pods: $should_install_pods"
echo "should_update_repo: $should_update_repo"
echo "should_clear_derived_data: $should_clear_derived_data"
