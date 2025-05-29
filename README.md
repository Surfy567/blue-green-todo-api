# Blue-Green CI/CD with GitHub Actions & Docker Compose

## Overview

This project implements a simple CI/CD pipeline using GitHub Actions to deploy a Node.js To-Do API using Docker Compose. It sets up a basic blue-green deployment structure using two app containers (todo-blue and todo-green) behind an Nginx reverse proxy (todo-proxy).

Currently, automatic switching between environments and health checks are **not yet implemented**. All containers are rebuilt and restarted on every deployment.


## Features

- Node.js REST API for managing To-Do items.

- Dockerized app, running on port 3000.

- Blue-Green deployment using Docker containers.

- Nginx reverse proxy (todo-proxy) routes traffic to the active environment.

- Fully automated CI/CD pipeline with GitHub Actions.

- Deployment on a self-hosted runner environment.






## Architecture

- **Blue environment**: One instance of the app running Docker container.

- **Green environment**: Second instance, identical to Blue, updated during deployment.

- **Nginx Reverse Proxy**: Serves as the entry point and routes traffic to the active environment (either blue or green).

- **GitHub Actions**: Workflow triggers on push to **main** branch, builds, tests, deploys, performs health check, then switches traffic.

- **Self-hosted runner**: Executes the workflow on a dedicated machine/VM.

  

## Prerequisites

- Docker and Docker Compose installed on the deployment host.

- Node.js installed for local development.

- GitHub repository with Actions enabled.

- Self-hosted runner is configured and connected to GitHub.

- Port 3000 is available on the deployment machine.
  

## Setup & Usage

### Clone the repository

<pre lang="markdown"> git clone git@github.com/Surfy567/blue-green-todo-api 
 cd blue-green-todo-api </pre>

### Running locally (development)

<pre lang="markdown"> npm install 
 npm start </pre>

 The API will run on http://localhost:3000
 
 

 ## CI/CD Pipeline

 The GitHub Actions workflow **deploy.yml** runs on every push to **main** and performs the following:

1. Checks out the latest code.

2. Installs the Docker Compose plugin on the self-hosted runner.

3. Stops and removes existing containers (blue, green, and proxy).

4. Rebuilds and redeploys all containers using Docker Compose.

5. Traffic is served via Nginx based on static configuration.

At this stage, the pipeline does not alternate environments, perform health checks, or dynamically switch traffic. These are planned improvements.


## Deployment details

- All containers (todo-blue, todo-green, and todo-proxy) are rebuilt and redeployed on every run.

- Nginx (todo-proxy) statically routes traffic to either the blue or green container — this is configured manually in nginx/nginx.conf.

- The app is accessible on port 3000 via the reverse proxy.

- This setup currently results in minimal downtime, but is not yet zero-downtime.


 ## Troubleshooting

- Ensure Docker Daemon is running on your deployment machine.

- Verify the self-hosted runner is active and connected to your repo.

- Make sure port 3000 is not blocked or in use by another app.

- Review GitHub Actions logs for deployment failures.


## Contribution

This project is intended as a learning/demo resource. Feel free to fork, improve, or use the pipeline as a template for your projects.



