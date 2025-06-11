# Roots Bedrock for WordPress running on Docker

This is a Docker-based local development environment for WordPress with Roots Bedrock.

## SSH Access

You can access the WordPress/PHP container with `docker compose exec`.

```bash
docker compose exec --user root php-fpm bash
```

Alternatively, there is a script in the `/bin` directory that allows you to SSH in to the environment 
from the project directory directly: `./bin/ssh.sh <user>`.
