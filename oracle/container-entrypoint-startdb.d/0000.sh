set -e

lsnrctl services
echo 'user: '${USER:-<is empty>}
env
pwd
ls -l
ls -l /container-entrypoint-startdb.d

cat <<EOF > /container-entrypoint-startdb.d/connect.sql
prompt OVERRIDE CONNECT
connect ${APP_USER}/${APP_USER_PASSWORD}@"(DESCRIPTION =(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${ORACLE_DATABASE})))";
prompt OVERRIDE CONNECT DONE
EOF

cat /container-entrypoint-startdb.d/connect.sql
echo '**** SUCCESS'