#!/bin/bash
# Import common functions
source common.sh

if [ $# -lt 1 ]; then
  echo "Script must be called with 1 parameters"
  echo "<script> DEVICE_IP"
  exit 2
fi
DEVICE_IP=$1

if [ -z $API_KEY ]; then
  echo "API_KEY environment variable must be set."
fi
if [ -z $API_HOST ]; then
  echo "API_HOST environment variable must be set."
fi

## This is the actual start of the script.

# Check whether the device is enrolled to any domain
if find_enrolled_device_by_ip $DEVICE_IP; then
  echo "[Info] Device $DEVICE_IP is found with $DEVICE_ID"
  if trigger_device_unenrollment $DEVICE_ID; then
    echo "[Info] Device unenrollment triggered, continuing to verify that the device unenrollment succeeded..."
  else
    echo "[Error] Device unenrollment failed"
    exit 1
  fi
else
  echo "[Warning] Failed to find enrolled device with IP ${DEVICE_IP}"
  exit 0
fi

# Verify that the device unenrollment finished
findUnenrolledDeviceRetry=0
while [[ true ]]; do
  if find_unenrolled_device_by_ip $DEVICE_IP; then
    echo "[Info] Device $DEVICE_IP unenrollment confirmed."
    exit 0
  else
    if [ $findUnenrolledDeviceRetry -le 4 ]; then
      echo "[Info] Device $DEVICE_IP cannot be found in unenrolled devices, retry .. $findUnenrolledDeviceRetry"
      sleep 5
      let findUnenrolledDeviceRetry++
    else
      echo "[Warning] Failed to verify that the device unenrollment succeeded. Continuing anyway."
      exit 0
    fi
  fi
done
