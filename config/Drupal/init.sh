#!/bin/bash

/opt/techm-corporate-website/vendor/bin/drush cr
set -m
nginx -g "daemon off;" &
php-fpm
