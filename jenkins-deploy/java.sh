#!/bin/bash
set -o nounset
set -o errexit


if which apt-get; then
  apt-get update
  apt-get install -y "openjdk-7-jre"


elif which yum; then
  # Installing EPEL is a bit more complex than it should.
  rhel_version="$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)"
  if [ 6 -eq "${rhel_version}" ]; then
    epel_pkg_ver="8"
  elif [ 7 -eq "${rhel_version}" ]; then
    epel_pkg_ver="5"
  else
    echo "Unsupported OS"
    exit 1
  fi

  pkg_arch="$(rpm -q bash --qf '%{ARCH}')" # Why bash? Because this is a bash script anyways.

  if rpm -q epel-release; then
    echo "EPEL installed"
  else
    rpm -Uvh "http://download.fedoraproject.org/pub/epel/${rhel_version}/${pkg_arch}/epel-release-${rhel_version}-${epel_pkg_ver}.noarch.rpm"
  fi

  if java -version | grep libgcj; then
    yum remove java
  fi
  yum install -y "java-1.6.0-openjdk"


else
  echo "Unsupported distribution!"
  exit 1
fi

