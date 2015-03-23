#!/bin/bash
set -o errexit
set -o nounset

: ${JENKINS_LAST_BUILD:="No build ID!"}

# Install all dependencies
if which apt-get; then
  apt-get update
  apt-get install -y apache2
elif which yum; then
  yum -y install httpd
else
  echo "Unsupported OS"
  exit 1
fi

if [ -d "/var/www/html" ]; then
  WWW_ROOT="/var/www/html"
else
  WWW_ROOT="/var/www"
fi

echo "Deployed a 'build' with ID: '${JENKINS_LAST_BUILD}'" > "${WWW_ROOT}/index.html"
