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

  wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
  echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list

  apt-get update
  apt-get install -y "jenkins"


elif which yum; then
  yum install -y wget

  wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
  rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

  yum install -y "jenkins"


else
  echo "Unsupported distribution!"
  exit 1
fi

service jenkins start || true   # Just make sure it's running
service jenkins status          # Check what the status
