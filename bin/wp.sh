#!/bin/bash

docker compose exec --user www-data php-fpm wp "$@"
