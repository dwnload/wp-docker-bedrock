#!/bin/bash

if [ -f "./site/web/wp/index.php" ];
then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php --install-dir=bin
    php -r "unlink('composer-setup.php');"
    php ./bin/composer.phar --working-dir=site/ install
fi