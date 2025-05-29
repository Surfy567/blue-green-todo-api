# Blue Green ToDo API

## Overview

This repository contains a simple Node.js To-Do API application configured for Blue-Green deployment using Docker and GitHub Actions. The project demonstrates a fully automated CI/CD pipeline with zero downtime deployment on a self-hosted runner.

The Blue-Green deployment strategy ensures that new versions of the application can be released safely by switching traffic between two identical environments (**blue** and **green**), minimizing risks and downtime.


## Features

- Node.js REST API for managing To-Do items.

- Dockerized app, running on port 3000.

- Blue-Green deployment using Docker containers.

- Fully automated CI/CD pipeline with GitHub Actions.

- Deployment on a self-hosted runner environment.

- Automated health checks before traffic switch.




## Architecture

- Blue environment: One instance of the app running Docker container.

- Green environment: Second instance, identical to Blue, updated during deployment.

- GitHub Actions: Workflow triggers on push to **main** branch, builds, tests, deploys, performs health check, then switches traffic.

- Self-hosted runner: Executes the workflow on a dedicated machine/VM.

  

## Prerequisites

- Docker is installed on the deployment host.

- Node.js is installed for local development.

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

1. Builds the Docker image for the new version.

2. Deploys the container to the inactive environment (blue or green).

3. Runs automated health checks on the new environment.

4. If successful, switches the traffic to the new environment.

5. Cleans up the old environment.


## Deployment details

- The pipeline uses tags **blue** and **green** to deploy alternating environments.

- Health checks ensure the new deployment is healthy before switching traffic.

- The active environment is exposed on port 3000 for end-users.

- The entire process ensures zero downtime.


 ## Troubleshooting

 - Ensure Docker daemon is running on your deployment machine.

- Verify self-hosted runner is active and connected.

- Check port 3000 is not blocked or used by another app.

- Review GitHub Actions logs for deployment failures.


## Contribution

This project is intended as a learning/demo resource. Feel free to fork, improve, or use the pipeline as a template for your projects.



