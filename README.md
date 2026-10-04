<h1>
<p align="center">
<a href="https://github.com/GnomeShift/Caddy-pipeline" target="_blank" rel="noopener noreferrer">Caddy-pipeline</a>
</p>
</h1>

# 🌐 Overview
Pipeline for custom [Caddy](https://caddyserver.com/)-alpine Docker images builds.

[![Custom Caddy image build](https://img.shields.io/github/actions/workflow/status/GnomeShift/Caddy-pipeline/build-caddy.yml?logo=github&label=Build%20Caddy)](https://github.com/GnomeShift/Caddy-pipeline/actions/workflows/build-caddy.yml)
[![Docker image size](https://img.shields.io/docker/image-size/gnomeshift/caddy-test?logo=docker)](https://hub.docker.com/r/gnomeshift/caddy-test)
[![License](https://img.shields.io/github/license/GnomeShift/Caddy-pipeline?color=%239944ee)](https://github.com/GnomeShift/Caddy-pipeline/blob/master/LICENSE)

## 🌟 Features
- Latest Caddy version autodetect.
- Docker Hub bypass mode to build directly from GitHub (e.g., latest tag isn't pushed to Docker Hub yet).
- Caddy modules support.
- Multi-arch (linux/amd64, linux/arm64).
- Manual start via GitHub Actions.

## 🚀 Quick start
1. Add secret `DOCKERHUB_PASSWORD` and variable `DOCKERHUB_LOGIN` on the `Settings` -> `Secrets and variables` -> `Actions` tab.
2. Start pipeline via GitHub Actions.
3. Specify build params (optional):
   - Caddy modules to include (space-separated, default: `github.com/caddy-dns/cloudflare github.com/greenpau/caddy-security github.com/mholt/caddy-l4`).
   - Docker image name (default: caddy).
   - Caddy version to build (default: latest).
4. Click on `Run workflow` button.
5. Done! You can view build summary on the pipeline page.

<p align="center">
   <i>© GnomeShift 2026 - present</i><br>
   <i>Licensed under <a href="https://github.com/GnomeShift/Caddy-pipeline/blob/HEAD/LICENSE">Apache-2.0</a></i><br><br>
   <i>Credits:</i><br>
   <i><a href="https://github.com/caddyserver/caddy/blob/master/LICENSE">Caddy</a> licensed under Apache-2.0</i><br>
</p>
