#!/bin/bash

# Pass in your desired user, like `root`. Defaults to `www-data`.
USER=${1-www-data}
docker compose exec --user "$USER" php-fpm bash
