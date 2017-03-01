#!/bin/bash

if [ -f "./site/web/wp/index.php" ];
then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php --install-dir=bin
    php -r "unlink('composer-setup.php');"
    php ./bin/composer.phar --working-dir=site/ install
fi