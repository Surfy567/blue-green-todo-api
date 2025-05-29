#!/bin/bash

set -e

# Accept environment name (blue or green)
ENV=$1

if [[ "$ENV" != "blue" && "$ENV" != "green" ]]; then
  echo "Usage: ./deploy.sh [blue|green]"
  exit 1
fi

TARGET="todo-$ENV"

echo "Validating Nginx upstream to point to: $TARGET:3000"

# Update Nginx config
cat > ./nginx/nginx.conf <<EOF
events {}

http {
    upstream todo-app {
        server $TARGET:3000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://todo-app;
        }

        location /health {
            proxy_pass http://todo-app/health;
        }
    }
}
EOF

echo "Cleaning up old containers if any..."
docker rm -f todo-blue todo-green todo-proxy 2>/dev/null || true

echo "Rebuilding and launching containers..."
docker-compose up -d --build

echo "Reloading Nginx config..."
docker exec todo-proxy nginx -s reload

echo "Verifying health endpoint for $TARGET..."
docker exec todo-proxy curl -sf http://$TARGET:3000/health && echo "$TARGET is healthy" || {
  echo "$TARGET failed health check"
  exit 1
}
