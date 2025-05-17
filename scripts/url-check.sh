#!/bin/bash
maxTime=60
url=""
content=""

if [ $# -lt 2 ]; then
  echo "Usage: $0 <url> <content>"
  echo "Example: $0 http://example.com 'Example Domain'"
  exit 1
fi

url=$1
content=$2

# Check third argument for maxTime
if [ $# -eq 3 ]; then
  maxTime=$3
fi

echo "🔍 URL Check Script"
echo "--------------------------------"
echo "URL: $url"
echo "Content to check: '$content'"
echo "Max time to wait: $maxTime seconds"
echo "--------------------------------"


declare -i count=0
while (( $count < $maxTime )); do
  response=$(curl -s "$url")
  if [ $? -ne 0 ]; then
    echo "💥 Error: Unable to reach URL $url"
  fi

  if [[ $response == *"$content"* ]]; then
    echo "😁 URL check passed, content match found!"
    exit 0
  else  
    echo "😞 URL online, but content not found"
  fi

  # wait for 1 second before retrying
  sleep 1
  ((count++))
done

echo "💥 Giving up after $maxTime seconds, check failed!"
exit 1