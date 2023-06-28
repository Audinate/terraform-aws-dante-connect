#!/bin/bash
# Import common functions
source common.sh

if [ $# -lt 2 ]; then
  echo "Script must be called with 2 parameters"
  echo "<script> DANTE_DOMAIN DEVICE_IP"
  exit 2
fi
DOMAIN=$1
DEVICE_IP=$2

if [ -z $API_KEY ]; then
  echo "API_KEY environment variable must be set."
fi
if [ -z $API_HOST ]; then
  echo "API_HOST environment variable must be set."
fi

# Find the domain ID
# Parameter 1: Domain name to be found
# Returns 0 when the domain could be found.
function find_domain_id() {
  if [ $# -lt 1 ]; then
    echo "find_domain_id requires at least 1 arguments"
    exit 1
  fi

  local DomainName=$1

  local Query="{\"query\":\"query Query(\$name: String) {\n domain(name: \$name){\n    id\n}\n}\n\",\"variables\":{\"name\":\"${DomainName}\"},\"operationName\":\"Query\"}"

  local QueryResult
  if ! QueryResult=$(curl $CURL_OPTIONS -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    --data-raw "$Query" \
    "$API_HOST"); then
    echo "${CURL_ERROR_MESSAGE}"
    return 1
  fi

  DOMAIN_ID=$(echo $QueryResult | jq -r ".data.domain.id")

  echo "[Trace] Found domain id \"$DOMAIN_ID\" for Domain \"$DomainName\""
  if [[ -z $DOMAIN_ID || $DOMAIN_ID == "null" ]]; then
    echo "[Error] Failed to find domain ${DOMAIN}! You might need to create the domain first. (${QueryResult})"
    return 1
  else
    return 0
  fi
}

# Enroll the device based on the passed device id and domain id
# Parameter 1: The device id
# Parameter 2: The domain id
# Returns 0 when the device is correctly enrolled
function enroll_device() {
  if [ $# -lt 2 ]; then
    echo "enroll_device requires at least 2 arguments"
    exit 2
  fi

  local DeviceId=$1
  local DomainId=$2

  local Query="mutation DeviceEnroll(\$input: DevicesEnrollInput!) { DevicesEnroll(input: \$input) { ok } }"
  local Variables="{\"input\" : { \"domainId\" : \"$DomainId\", \"deviceIds\" : [ \"$DeviceId\" ] } }"

  local QueryResult
  if ! QueryResult=$(curl $CURL_OPTIONS \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    --data-raw "{ \"query\": \"$Query\",\"variables\": $Variables }" \
    $API_HOST); then
    echo "${CURL_ERROR_MESSAGE}"
    return 1
  fi

  local ParsedResult=$(echo $QueryResult | jq .data.DevicesEnroll.ok)
  if [[ $ParsedResult == "true" ]]; then
    echo "[Info] Enrollment succeeded of device $DeviceId into domain $DomainId "
    return 0
  else
    echo "[Error] Enrollment failed! ($QueryResult)"
    return 1
  fi
}

# Configure unicast clocking for the device
# Parameter 1: The device id
# Returns 0 when the device is correctly configured
function configure_unicast() {
  if [ $# -lt 1 ]; then
    echo "configure_unicast requires at least 1 argument"
    exit 2
  fi

  local DEVICE_ID=$1
  local Variables='"variables":{"input":{"deviceId":"'"$DEVICE_ID"'","enabled":true}}'
  local Query='"mutation ChangeUnicastClockingForDevicePayload($input:\r\nDeviceClockingUnicastSetInput!) {\r\n    DeviceClockingUnicastSet(input:$input){\r\n        ok\r\n    }\r\n}\r\n\r\n  \r\n"'

  local QueryResult
  if ! QueryResult=$(curl $CURL_OPTIONS \
    -H "Authorization: $API_KEY" \
    -H "Content-Type: application/json" \
    --data-raw '{"query":'"$Query"','"$Variables"'}' \
    $API_HOST); then
    echo "${CURL_ERROR_MESSAGE}"
    return 1
  fi

  local ParsedResultUnicast=$(echo $QueryResult | jq .data.DeviceClockingUnicastSet.ok)
  if [[ $ParsedResultUnicast == "true" ]]; then
    echo "[Info] Configuring unicast succeeded"
    return 0
  else
    echo "[Error] Configure unicast failed! ($QueryResult)"
    return 1
  fi
}

## This is the actual start of the script.

# Find the passed domain
if find_domain_id "$DOMAIN"; then
  echo "[Info] Domain $DOMAIN \"$DOMAIN_ID\" found"
  DOMAIN_ID=$DOMAIN_ID
else
  echo "[Fatal] Failed to find domain $DOMAIN"
  exit 1
fi

# Check whether the device is already enrolled to any domain
if find_enrolled_device_by_ip $DEVICE_IP; then
  if [ "$DOMAIN_NAME" == "$DOMAIN" ]; then
    echo "[Info] Device $DEVICE_IP $DEVICE_ID already enrolled in \"$DOMAIN_NAME\", configure unicast clocking"
    # Configure unicast settings
    if configure_unicast $DEVICE_ID $DOMAIN_ID; then
      echo "[Info] Device configured with unicast clocking"
      exit 0
    else
      echo "[Error] Failed to configure unicast clocking"
      exit 1
    fi
  else
    echo "[Warning] Device $DEVICE_IP $DEVICE_ID enrolled in wrong domain \"$DOMAIN_NAME\", updating to domain \"$DOMAIN\"."
    trigger_device_unenrollment $DEVICE_ID
  fi
else
  echo "[Info] Device not yet enrolled, waiting for device to be registered in DDM"
fi

# Check whether we find the device as unenrolled device, it might take a while for the device to come online
findDeviceRetry=0
while [[ ($findDeviceRetry -le 60) && (-z $DEVICE_ID) ]]; do
  if find_unenrolled_device_by_ip $DEVICE_IP DEVICE_ID; then
    echo "[Info] Device $DEVICE_IP is found with $DEVICE_ID"
    DEVICE_ID=$DEVICE_ID
  else
    echo "[Info] Device cannot be found, retry .. $findDeviceRetry"
    sleep 5
  fi
  let findDeviceRetry++
done

# Enroll the device into the domain
enrollDeviceRetry=0
while [[ ($enrollDeviceRetry -le 5) && (-z $ENROLLED_DEVICE_ID) ]]; do
  if enroll_device $DEVICE_ID $DOMAIN_ID $DEVICE_IP; then
    if find_enrolled_device_by_ip $DEVICE_IP DEVICE_ID; then
      echo "[Info] Device $DEVICE_IP is found with $DEVICE_ID"
      ENROLLED_DEVICE_ID=$DEVICE_ID
    else
      echo "[Info] Device was not enrolled, retry .. $enrollDeviceRetry"
      sleep 5
    fi
    let enrollDeviceRetry++
  else
    echo "[Error] Device failed to enroll"
    exit 1
  fi
done

# Configure unicast settings
configureUnicastRetry=0
while [[ true ]]; do
  if configure_unicast $DEVICE_ID $DOMAIN_ID; then
    echo "[Info] Device configured with unicast clocking"
    exit 0
  else
    if [ $configureUnicastRetry -le 5 ]; then
      echo "[Warning] Failed to configure unicast clocking. Retry."
      sleep 5
    else
      echo "[Error] Failed to configure unicast clocking. Giving up."
      exit 1
    fi
  fi
  let configureUnicastRetry++
done
