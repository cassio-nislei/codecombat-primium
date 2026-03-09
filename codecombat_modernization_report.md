# CodeCombat Repository Modernization Report

Author: System Analysis Date: 2026

------------------------------------------------------------------------

# 1. Executive Summary

The open-source CodeCombat repository currently depends on an outdated
ecosystem of tools and libraries. Many dependencies are deprecated,
removed from registries, or incompatible with modern Node.js
environments.

Major issues include:

-   Deprecated npm packages
-   Node.js version incompatibilities
-   Broken tarball URLs
-   Bower dependency manager (deprecated)
-   Vue 2 end-of-life
-   Webpack 3 build system
-   Ruby scripts and legacy tooling
-   Removed npm packages such as `node-force-domain`

The project currently builds unreliably in modern environments.

Modernization is required to restore build stability and
maintainability.

------------------------------------------------------------------------

# 2. Current Architecture Overview

Current stack:

Backend - Node.js - Express - MongoDB

Frontend - Vue 2 - Webpack 3 - CoffeeScript - Jade templates

Infrastructure - Docker (development only) - Ruby scripts (rbenv) -
Bower dependency manager

------------------------------------------------------------------------

# 3. Major Technical Problems

## 3.1 Node.js Compatibility

Original expected runtime:

Node 10--16 npm 6

Modern environments use:

Node 20+ npm 10+

This causes dependency resolution failures.

Temporary fix:

Node 16 + npm 6

Long-term fix:

Upgrade project to Node 20.

------------------------------------------------------------------------

## 3.2 Removed npm Packages

Example removed dependency:

node-force-domain

Error seen during install:

"No valid versions available"

Mitigation:

Install from GitHub:

npm install github:codecombat/node-force-domain

------------------------------------------------------------------------

## 3.3 package-lock.json Corruption

Legacy lockfiles cause:

-   integrity checksum errors
-   tarball download failures

Fix:

rm package-lock.json npm install

------------------------------------------------------------------------

# 4. Deprecated Libraries

Examples currently used:

  Library        Status
  -------------- ----------------
  Vue 2          End of Life
  Bootstrap 3    Deprecated
  Request        Deprecated
  Node Sass      Deprecated
  CoffeeScript   Legacy
  Jade           Renamed to Pug
  Webpack 3      Deprecated
  Bower          Discontinued

------------------------------------------------------------------------

# 5. Required Dependency Upgrades

Frontend upgrades:

Vue 2 → Vue 3\
Vuex → Pinia\
Bootstrap 3 → Bootstrap 5\
node-sass → sass\
jade → pug

Build tooling:

Webpack 3 → Webpack 5\
extract-text-webpack-plugin → mini-css-extract-plugin

------------------------------------------------------------------------

# 6. Backend Updates

Replace deprecated libraries:

request → axios

Update MongoDB driver to modern version compatible with MongoDB 6+.

------------------------------------------------------------------------

# 7. Bower Removal

Current command:

bower install

Bower was discontinued in 2017.

Migration steps:

1.  Identify Bower dependencies
2.  Replace with npm equivalents
3.  Remove Bower configuration

------------------------------------------------------------------------

# 8. Ruby Dependency

Project uses:

Ruby 2.6 via rbenv

Recommendation:

Rewrite Ruby scripts in Node.js and remove Ruby dependency.

------------------------------------------------------------------------

# 9. MongoDB Compatibility

Original environment:

MongoDB 3.x

Recommended upgrade:

MongoDB 6+

------------------------------------------------------------------------

# 10. Security Issues

Dependencies with vulnerabilities include:

-   lodash (old versions)
-   axios (old versions)
-   request
-   hoek
-   hawk
-   core-js v2

These must be updated.

------------------------------------------------------------------------

# 11. Docker Issues

Original problems:

-   Debian Buster EOL
-   npm incompatibilities
-   removed npm packages

Recommended base image:

node:20-bookworm

------------------------------------------------------------------------

# 12. Modernization Roadmap

## Phase 1 --- Stabilize Build

Tasks:

-   pin Node 16
-   use npm 6
-   replace removed packages
-   remove package-lock.json

Estimated time: 1--3 days

------------------------------------------------------------------------

## Phase 2 --- Dependency Cleanup

Tasks:

-   replace request
-   migrate jade → pug
-   replace node-sass
-   remove Bower

Estimated time: 3--5 days

------------------------------------------------------------------------

## Phase 3 --- Frontend Modernization

Tasks:

Vue 2 → Vue 3\
Vuex → Pinia\
Webpack 3 → Webpack 5

Estimated time: 1--2 weeks

------------------------------------------------------------------------

## Phase 4 --- Infrastructure Modernization

Tasks:

-   modern Dockerfile
-   docker-compose stack
-   MongoDB + Redis
-   CI pipeline

Estimated time: 2--3 days

------------------------------------------------------------------------

# 13. Recommended Modern Stack

Backend:

Node 20\
Express\
MongoDB 6\
Redis

Frontend:

Vue 3\
Pinia\
Vite\
Bootstrap 5

Tooling:

Docker\
Docker Compose\
ESLint\
Prettier\
GitHub Actions

------------------------------------------------------------------------

# 14. Estimated Effort

Full modernization:

2--4 weeks

Team size:

1--2 developers

------------------------------------------------------------------------

# 15. Final Recommendation

Modernization should be done as a **progressive refactor**, focusing on:

1.  Stabilizing build
2.  Removing deprecated dependencies
3.  Upgrading frontend framework
4.  Modernizing infrastructure

------------------------------------------------------------------------

End of Report
