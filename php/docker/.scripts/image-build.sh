#!/usr/bin/env bash
#------------------------------------------------------------------------------
set -e

printf '=%.0s' {1..80} && echo ""
echo '>> '$0

. setEnv.sh
echo 'imgName='${imgName}

# Создаем новый образ
docker build --tag ${imgName} .
if [ ! "$?" == "0" ]; then
  echo "-- Error build image ${imgName}"
  exit 1
fi
#------------------------------------------------------------------------------
