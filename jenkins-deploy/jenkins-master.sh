#!/bin/bash
set -o nounset
set -o errexit

JENKINS_HOME="/var/lib/jenkins"
JENKINS_USER="jenkins"

# Create Jenkins
useradd --home "${JENKINS_HOME}" --shell "/bin/bash" "${JENKINS_USER}" || echo "User ${JENKINS_USER} already exists"

# Chown home if necessary (we're mounting a volume there; it might exist already)
chown "${JENKINS_USER}:${JENKINS_USER}" "${JENKINS_HOME}"

# Install Jenkins

if which apt-get; then
  apt-get update
  apt-get install -y wget

  wget "http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_1.651.3_all.deb"
  dpkg -i jenkins_1.651.3_all.deb

elif which yum; then
  yum install -y wget

  wget "http://pkg.jenkins-ci.org/redhat-stable/jenkins-1.651.3-1.1.noarch.rpm"
  rpm -ivh jenkins-1.651.3-1.1.noarch.rpm

else
  echo "Unsupported distribution!"
  exit 1
fi

service jenkins start || true   # Just make sure it's running
service jenkins status          # Check what the status

