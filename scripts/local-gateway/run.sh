#!/bin/bash

# =========================================================================
# Starts the local version of the API gateway using Docker and NGINX
# =========================================================================

docker rm -f api-gateway || true

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

dapr run --app-id api-gateway \
  --app-port 9000 \
  --log-level warn \
  --dapr-http-port 3501 \
  --resources-path "$scriptDir/../../components" \
  -- docker run --rm --network host --mount type=bind,source="$scriptDir",target=/etc/nginx/conf.d/ --name api-gateway nginx:alpine
