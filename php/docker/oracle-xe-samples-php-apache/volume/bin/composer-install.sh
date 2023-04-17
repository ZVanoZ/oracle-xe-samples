#!/usr/bin/env bash
#------------------------------------------------------------------------------
printf '=%.0s' {1..80} && echo ""
echo '>script: '$0

echo 'pwd:'
pwd

echo 'home:'
ls -l ~

cd /var/www
echo 'pwd:'
pwd
ls -l

echo 'run composer update:'
composer --no-interaction -v install
#------------------------------------------------------------------------------
