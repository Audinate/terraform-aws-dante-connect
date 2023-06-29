#!/bin/bash
# This file holds functions used by both the enroll and unenroll device script.

export CURL_OPTIONS="-s -f"
export CURL_ERROR_MESSAGE="[Error] Request failed. Please check if the provided API_HOST variable is correct and if the host is reachable."

# Find the enrolled device based on the passed IP
# Updates variables DEVICE_ID and DOMAIN_NAME with the result
# Parameter 1: IP to be found
# Returns 0 when the device could be found.
function find_enrolled_device_by_ip() {
  if [ $# -lt 1 ]; then
    echo "find_enrolled_device_by_ip requires at least 1 arguments"
    exit 2
  fi

  local IP=$1

  local Query="query GetEnrolledDevices { domains { name devices { enrolmentState id name interfaces { address } name } } }"

  local QueryResult
  if ! QueryResult=$(curl $CURL_OPTIONS \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    --data-raw "{ \"query\": \"$Query\" }" \
    $API_HOST); then
    echo "${CURL_ERROR_MESSAGE}"
    return 1
  fi

  DEVICE_ID=$(echo $QueryResult | jq -r -c ".data.domains[].devices[] | select( .interfaces[].address == \"$IP\") | .id")
  DOMAIN_NAME=$(echo $QueryResult | jq -r -c ".data.domains[] | select( .devices[].interfaces[].address == \"$IP\") | .name")
  ENROLMENT_STATE=$(echo $QueryResult | jq -r -c ".data.domains[].devices[] | select( .interfaces[].address == \"$IP\") | .enrolmentState")

  echo "[Trace] Query result: GetEnrolledDevices \"$DEVICE_ID,$DOMAIN_NAME,$ENROLMENT_STATE\" (${QueryResult})"
  if [[ (-z $DEVICE_ID || $DEVICE_ID == "null") || ($ENROLMENT_STATE != "ENROLLED") ]]; then
    return 1
  else
    return 0
  fi
}

# Find the device based on the passed IP
# Updates variable DEVICE_ID with the result
# Parameter 1: IP to be found
# Returns 0 when the device could be found.
function find_unenrolled_device_by_ip() {
  if [ $# -lt 1 ]; then
    echo "find_unenrolled_device_by_ip requires at least 1 arguments"
    exit 2
  fi

  local IP=$1

  local Query="query GetUnenrolledDevices { unenrolledDevices { enrolmentState id name interfaces { address } } }"

  local QueryResult
  if ! QueryResult=$(curl $CURL_OPTIONS \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    --data-raw "{ \"query\": \"$Query\" }" \
    $API_HOST); then
    echo "${CURL_ERROR_MESSAGE}"
    return 1
  fi

  DEVICE_ID=$(echo $QueryResult | jq -r -c ".data.unenrolledDevices[] | select( .interfaces[].address == \"$IP\") | .id")
  ENROLMENT_STATE=$(echo $QueryResult | jq -r -c ".data.unenrolledDevices[] | select( .interfaces[].address == \"$IP\") | .enrolmentState")

  echo "[Trace] Query result: GetUnenrolledDevices \"$DEVICE_ID,$ENROLMENT_STATE\", looking for \"$IP\""
  if [[ (-z $DEVICE_ID || $DEVICE_ID == "null") || ($ENROLMENT_STATE != "UNENROLLED") ]]; then
    return 1
  else
    return 0
  fi
}

# Trigger the device unenrollment based on the passed device id
# Parameter 1: The device id
# Returns 0 when the device unenrollment has successfully been triggered
function trigger_device_unenrollment() {
  if [ $# -lt 1 ]; then
    echo "trigger_device_unenrollment requires at least 1 argument"
    exit 2
  fi

  local deviceId=$1

  local Query="mutation DeviceUnenroll(\$input: DevicesUnenrollInput!) { DevicesUnenroll(input: \$input) { ok } }"
  local Variables="{\"input\" : { \"deviceIds\" : [ \"$deviceId\" ] } }"

  local QueryResult
  if ! QueryResult=$(curl $CURL_OPTIONS \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    --data-raw "{ \"query\": \"$Query\", \"variables\": $Variables }" \
    $API_HOST); then
    echo "${CURL_ERROR_MESSAGE}"
    return 1
  fi

  local ParsedResult=$(echo $QueryResult | jq .data.DevicesUnenroll.ok)
  if [[ $ParsedResult == "true" ]]; then
    echo "[Info] Unenrollment successfully triggered"
    return 0
  else
    echo "[Error] Unenrollment trigger failed! ($QueryResult)"
    return 1
  fi
}
