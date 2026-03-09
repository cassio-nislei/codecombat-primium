FROM node:20-bookworm

ARG RUBY_VERSION=2.7.0
ENV NPM_GLOBAL_PREFIX=/npm

WORKDIR /coco

ENV PATH=$PATH:/root/.rbenv/bin:/root/.rbenv/shims

# Install dependencies for Ruby compilation
RUN apt-get update && apt-get install -y \
  git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison \
  build-essential libyaml-dev libncurses5-dev libffi-dev libgdbm-dev && \
  curl -sL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash -

# Install Ruby via rbenv
RUN rbenv install ${RUBY_VERSION} && rbenv global ${RUBY_VERSION}

# Setup npm global prefix
RUN mkdir -p $NPM_GLOBAL_PREFIX && \
  npm config set prefix $NPM_GLOBAL_PREFIX --global && \
  npm install -g npm@10

# Copy project
COPY . .
