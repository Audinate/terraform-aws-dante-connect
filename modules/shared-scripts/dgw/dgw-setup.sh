#!/bin/bash
# Copyright 2023-2025 Audinate Pty Ltd ACN 120 828 006 (Audinate). All rights reserved.
# Script for installing Dante Gateway (on an Ubuntu 20.04 Server Image)
# This script requires the DGW_VERSION env variable to be set prior to execution
set -euxo pipefail

log_msg()
{
	echo "DGW-Install: $1" >> /var/log/dgw-setup.log
}

log_msg "Starting ..."

# Update package indexes. Note the double apt-get update. This is required to also get the AWS archives in.
apt-get update && apt-get update

INSTALLER=dante_gateway_${DGW_VERSION}_x86_64_Linux.deb

log_msg "Downloading the DGW installer from ${DGW_RESOURCE_URL}/${INSTALLER} ..."

# Download the Dante Gateway
wget "${DGW_RESOURCE_URL}/${INSTALLER}" -P /opt

log_msg "Installing DGW .."

# Install the Dante Gateway
apt-get install "/opt/${INSTALLER}" -y

# Cleanup
apt-get clean
rm -rf "/opt/${INSTALLER}"

log_msg "Done"
