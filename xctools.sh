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

xcode_path="/Applications/Xcode.app/Contents/MacOS/Xcode"
is_xcode_working=`ps aux | grep "$xcode_path" | grep -v "grep" | awk '{print $2}'`

if [ ! -z "$is_xcode_working" ] ; then
  killall Xcode
fi

pods_dir_path=`find . -type d -name "Pods"`
podfilelock_path=`find . -type f -name "Podfile.lock" | grep -v "Pods"`

set -e
if [ -d "$pods_dir_path" ] ; then
  rm -rf "$pods_dir_path"
fi

if [ -f "$podfilelock_path" ] ; then
  rm "$podfilelock_path"
fi
set +e

if [ "$should_update_pods" -eq 1 ] ; then
  pod install --repo-update --project-directory="$podfile_path"
elif [ "$should_install_pods" -eq 1 ] ; then
  pod install --project-directory="$podfile_path"
fi

xcode_derived_data_path="~/Library/Developer/Xcode/DerivedData"
set -e
if [ "$should_clear_derived_data" -eq 1 ] ; then
  rm -rf "$should_clear_derived_data"
fi
set +e
