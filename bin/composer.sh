#!/bin/bash

docker-compose exec --user www-data phpfpm composer.phar --working-dir=site/ "$@"