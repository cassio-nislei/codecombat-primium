FROM node:20-bookworm

ENV NPM_GLOBAL_PREFIX=/npm

WORKDIR /coco

# Install system dependencies (simplified, no rbenv)
RUN apt-get update && apt-get install -y --no-install-recommends \
  git curl build-essential python3 make g++ && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup npm global prefix
RUN mkdir -p $NPM_GLOBAL_PREFIX && \
  npm config set prefix $NPM_GLOBAL_PREFIX --global && \
  npm install -g npm@10

# Copy project
COPY . .
