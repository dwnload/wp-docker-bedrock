#!/bin/bash

if [ -f "./site/web/wp/index.php" ];
then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php --install-dir=bin
    php -r "unlink('composer-setup.php');"
    php ./bin/composer.phar --working-dir=site/ install
fi
