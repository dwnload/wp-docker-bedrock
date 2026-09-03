# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based local development environment for WordPress using [Roots Bedrock](https://roots.io/bedrock/). It
is a GitHub template repository (`dwnload/wp-docker-bedrock`) providing a complete stack with MariaDB, Nginx, PHP-FPM,
and Redis.

## Key Architecture

**WordPress/Bedrock structure:**

- `web/` — the webroot, symlinked from Docker volumes
    - `web/wp/` — WordPress core (via Composer `roots/wordpress`)
    - `web/wp-config.php` — bootstrap that loads `config/application.php` then WordPress
    - `web/index.php` — simple bootstrap loading `wp-blog-header.php`
    - `web/app/themes/` — themes installed via Composer (e.g., twentytwentyfive)
    - `web/app/plugins/` — plugins installed via Composer
    - `web/app/mu-plugins/` — mu-plugins (bedrock-disallow-indexing)
    - `web/app/uploads/` — media uploads directory

**Configuration:**

- `config/application.php` — main WordPress config loader (env vars → `Config::define()` calls)
- `config/environments/*.php` — environment-specific overrides (development.php, staging.php)
- `config/nginx/default.conf` — Nginx virtual host config
- `config/php-fpm/php.ini` — PHP settings
- `config/ssl/` — self-signed SSL certs for local development

**Docker infrastructure (`docker-compose.yml`):**

- `mariadb` — MariaDB 11.5 (port 3306)
- `nginx` — Nginx with SSL (ports 8080→80, 9443→443)
- `php-fpm` — PHP 8.3-FPM with Xdebug option (builds from `Dockerfiles/php-fpm/Dockerfile`)
- `redis` — Redis 7.4 Alpine (internal port 6379, 128MB maxmemory)

**PHP Dependencies (`composer.json`):**

- Uses `wp-composer` repo (was wpackagist) for WordPress plugins/themes
- Composer installer paths: `web/app/plugins/`, `web/app/themes/`, `web/app/mu-plugins/`
- WordPress installs to `web/wp`
- PHP 8.3 minimum

## Running the Project

Start the full stack:

```bash
docker compose up -d
```

Access points:

- HTTP: `http://wp-docker-bedrock.test:8080`
- HTTPS: `https://wp-docker-bedrock.test:9443` (self-signed cert)
- MySQL: `localhost:3306`

Convenience scripts in `bin/`:

- `./bin/ssh.sh [user]` — SSH into the PHP-FPM container (`docker compose exec --user <user> php-fpm bash`)
- `./bin/wp.sh` — Run WP-CLI commands: `./bin/wp.sh <wp-cli args>`

WP-CLI is configured via `wp-cli.yml` (path: `web/wp`, docroot: `web`).

## Configuration

All environment variables are managed via `.env` (copied from `.env.example`). Key variables:

| Variable                                      | Purpose                                              |
|-----------------------------------------------|------------------------------------------------------|
| `PHP_VERSION`                                 | PHP version for Docker build (default: 8.3)          |
| `WITH_XDEBUG`                                 | Enable Xdebug in dev (default: true)                 |
| `WP_VERSION`                                  | WordPress version (default: 6.8.1)                   |
| `WP_ENV`                                      | Environment: local, development, staging, production |
| `SSL_MODE`                                    | SSL mode: mixed, http, https                         |
| `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, etc. | Database credentials                                 |

Edit `.env.example` when template defaults change; each clone should create its own `.env`.

## GitHub CI

Three workflows in `.github/workflows/`:

- `main.yml` — PHP Security Checker (on PR): runs `composer install` + Symfonycorp security-checker
- `deploy.yml` — (if present) deployment pipeline
- `typos.yml` — (if present) typo checking

Dependabot checks weekly for composer, docker-compose, and GitHub Actions updates.

## Development Notes

- **No npm/package.json** — this is a pure PHP/WordPress project. Build tools are not included.
- **Config is code, not env** — `config/application.php` maps `.env` variables to WordPress constants via
  `Roots\WPConfig\Config::define()`. Environment-specific overrides live in `config/environments/`.
- **Xdebug** — enabled by default in dev (`WITH_XDEBUG=true`), disabled in production builds. Dockerfile uses
  multi-stage build: `dev` (with xdebug, WP-CLI) and `deploy` (opcache enabled, no xdebug).
- **SSL** — self-signed certs at `config/ssl/localhost.{key,crt}`. The `.gitignore` does not ignore them (unlike
  `.env`).
- **Cron** — `DISABLE_WP_CRON` defaults to `false`. WP cron runs within requests.
- **File editing** — `DISALLOW_FILE_MODS` is true by default (no admin plugin/theme install/edit). Development
  environment overrides this to `false`.
