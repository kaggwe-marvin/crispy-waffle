#!/bin/bash

# Variables
REPO_NAME="hello-world-action"
WORKFLOW_DIR=".github/workflows"
SRC_DIR="src"
DIST_DIR="dist"
NODE_MODULES_DIR="node_modules"

# Create directories
mkdir -p $REPO_NAME/$WORKFLOW_DIR
mkdir -p $REPO_NAME/$SRC_DIR
mkdir -p $REPO_NAME/$DIST_DIR
mkdir -p $REPO_NAME/$NODE_MODULES_DIR

# Create .gitignore file
cat <<EOL > $REPO_NAME/.gitignore
node_modules
dist
EOL

# Create action.yml file
cat <<EOL > $REPO_NAME/action.yml
name: 'Hello World'
description: 'A simple hello world action'
inputs:
  who-to-greet:
    description: 'Who to greet'
    required: true
    default: 'World'
runs:
  using: 'node12'
  main: 'index.js'
EOL

# Create package.json file
cat <<EOL > $REPO_NAME/package.json
{
  "name": "hello-world-action",
  "version": "1.0.0",
  "description": "A simple hello world action",
  "main": "index.js",
  "scripts": {
    "test": "echo \\"Error: no test specified\\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "@actions/core": "^1.2.6"
  }
}
EOL

# Create index.js file
cat <<EOL > $REPO_NAME/index.js
const core = require('@actions/core');

async function run() {
  try {
    const nameToGreet = core.getInput('who-to-greet');
    console.log(\`Hello \${nameToGreet}!\`);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
EOL

# Create main.yml file for workflow
cat <<EOL > $REPO_NAME/$WORKFLOW_DIR/main.yml
name: "CI"

on:
  push:
    branches:
      - main

jobs:
  hello_world_job:
    runs-on: ubuntu-latest
    name: A job to say hello
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
      - name: Run hello-world-action
        uses: ./
        with:
          who-to-greet: 'World'
EOL

# Change directory to the repository and install dependencies
cd $REPO_NAME
npm install

echo "Setup complete. Your GitHub Action repository structure is ready."
