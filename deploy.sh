#!/bin/bash

set -e

echo "Starting Blue-Green Deployment..."

BLUE_RUNNING=$(docker ps --filter "name=blue" --format "{{.Names}}")

if [ -n "$BLUE_RUNNING" ]; then
  COLOR="green"
  OLD_COLOR="blue"
else
  COLOR="blue"
  OLD_COLOR="green"
fi

echo "New deployment will be: $COLOR"
echo "Old version (if running): $OLD_COLOR"


docker-compose -f docker-compose.$COLOR.yml up -d --build


echo "🔍 Running health check on new deployment..."
for i in {1..10}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/api/todos || true)
  if [ "$STATUS" == "200" ]; then
    echo "Health check passed."
    break
  fi
  echo "Waiting for $COLOR container to become healthy... ($i/10)"
  sleep 3
done

if [ "$STATUS" != "200" ]; then
  echo "Health check failed for $COLOR. Aborting deployment."
  docker-compose -f docker-compose.$COLOR.yml down
  exit 1
fi


echo "Swapping traffic to $COLOR..."
sudo cp ./nginx/$COLOR.conf /etc/nginx/conf.d/default.conf
sudo nginx -s reload


echo "Stopping old container: $OLD_COLOR"
docker-compose -f docker-compose.$OLD_COLOR.yml down

echo "Deployment complete."
