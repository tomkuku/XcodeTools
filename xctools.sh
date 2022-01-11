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

podfile_path=`find . -type f -name "Podfile" -exec dirname {} \; | grep -v "Pods"`

if [ "$(find . -type f -name "Podfile" | grep -v "Pods" | wc -l | awk '{print $1}')" -gt 1 ] ; then
  echo -e "\e[31mIn this directory is more then 1 Podfile!\e[0m"
  exit 1
fi

if [ -z "$podfile_path" ] ; then
  echo -e "\e[31mPodfile can not be found!\e[0m"
  exit 1
fi
