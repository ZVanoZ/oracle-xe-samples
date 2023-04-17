#!/bin/sh
#------------------------------------------------------------------------------
#переход в директорию текущего скрипта
cd $(dirname $(readlink -e $0))
#------------------------------------------------------------------------------
set -e
if [ -f 'initialize.sh' ]
then
  bash "initialize.sh"
else
  echo '--SKIP: initialize.sh'
fi

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid
exec apache2-foreground

#------------------------------------------------------------------------------