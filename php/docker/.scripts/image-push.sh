#!/usr/bin/env bash
#------------------------------------------------------------------------------
set -e

printf '=%.0s' {1..80} && echo ""
echo '>> '$0

. setEnv.sh
echo 'imgName='${imgName}

docker push ${imgName}:latest
#------------------------------------------------------------------------------