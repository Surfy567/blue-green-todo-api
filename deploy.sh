#!/bin/bash

APP_NAME="todo-api"
BLUE_PORT=3001
GREEN_PORT=3002

if lsof -i :$BLUE_PORT > /dev/null; then
  echo "Blue is running. Deploying Green..."
  docker rm -f ${APP_NAME}-green || true
  docker run -d --name ${APP_NAME}-green -p $GREEN_PORT:3000 blue-green-todo-api
  sleep 5
  curl -f http://localhost:$GREEN_PORT/health && {
    echo "Green is healthy. Switching traffic..."
    docker rm -f ${APP_NAME}-blue
    docker rename ${APP_NAME}-green ${APP_NAME}-blue
  } || {
    echo "Green failed. Keeping Blue."
    docker rm -f ${APP_NAME}-green
  }
else
  echo "Blue not running. Deploying on Blue..."
  docker rm -f ${APP_NAME}-blue || true
  docker run -d --name ${APP_NAME}-blue -p $BLUE_PORT:3000 blue-green-todo-api
fi