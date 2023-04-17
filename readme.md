# О проекте

Oracle на базе Docker образа "gvenzl/oracle"  
https://hub.docker.com/r/gvenzl/oracle-xe  
https://github.com//oci-oracle-xe  

# Как стартовать

Копируем ".env-dist" в корень проекта с именем ".env".
Редактируем .env под себя

Выполняем команду: 
```bash
docker compose up
```
При первом запуске будет собран образ и выполнятся скрипты в порядке:
````text
local.zvanoz.samples.oracle  | CONTAINER: running /container-entrypoint-initdb.d/*
local.zvanoz.samples.oracle  | CONTAINER: running /docker-entrypoint-initdb.d/*
local.zvanoz.samples.oracle  | CONTAINER: running /container-entrypoint-startdb.d/*

````

При последующих запусках будут выполны скрипты в порядке:
````text
local.zvanoz.samples.oracle  | CONTAINER: running /container-entrypoint-startdb.d/*
````

Соединение при помощи sqlplus 
```BASH
sqlplus ${APP_USER}/${APP_USER_PASSWORD}@"(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ${ORACLE_DATABASE})))"
```
Соединение внутри скрипта, который выполняется SQLPLUS
```SQLPLUS
# Так через SERRVICE_NAME из "/opt/oracle/homes/OraDBHome21cXE/network/admin/tnsnames.ora"
connect  dbuser/dbuser@xepdb1;
# Так из скрипта
connect MYUSERNAME/myUserPass@"(DESCRIPTION =(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=zimdbt)))"
```

# Другие примеры 

* https://github.com/gvenzl/oracle-xe-examples

# Ограничения

* В именах инициализационныз скриптов не достутны символы "@$" (Ограничение SQLPlus)
```text
000010-10-table-zim_values.sql Корректно
000010-10-table-zim$values.sql Ошибка
```
Лог:
````text
local.zvanoz.samples.oracle  | Session altered.
local.zvanoz.samples.oracle  | CONTAINER: DONE: running /container-entrypoint-startdb.d/000010-10-set-session.sql
local.zvanoz.samples.oracle  | 
-- тут видим что скрипт не выполнен 
local.zvanoz.samples.oracle  | CONTAINER: running /container-entrypoint-startdb.d/000010-10-table-zim$values.sql ...
local.zvanoz.samples.oracle  | SP2-0310: unable to open file "/container-entrypoint-startdb.d/000010-10-table-zim$values.sql"
local.zvanoz.samples.oracle  | CONTAINER: DONE: running /container-entrypoint-startdb.d/000010-10-table-zim$values.sql
local.zvanoz.samples.oracle  | 
local.zvanoz.samples.oracle  | CONTAINER: DONE: Executing user defined scripts.
local.zvanoz.samples.oracle  | 
local.zvanoz.samples.oracle  | 
local.zvanoz.samples.oracle  | #########################
local.zvanoz.samples.oracle  | DATABASE IS READY TO USE!
local.zvanoz.samples.oracle  | #########################
local.zvanoz.samples.oracle  | 
local.zvanoz.samples.oracle  | ##################################################################
local.zvanoz.samples.oracle  | CONTAINER: The following output is now from the alert_XE.log file:
local.zvanoz.samples.oracle  | ##################################################################
-- Тут видим, что все инициалиционные изменения отменены
local.zvanoz.samples.oracle  | ZIMDBT(4):Undo initialization online undo segments: err:0 start: 175438240 end: 175438263 diff: 23 ms (0.0 seconds)
local.zvanoz.samples.oracle  | ZIMDBT(4):Undo initialization finished serial:0 start:175438223 end:175438265 diff:42 ms (0.0 seconds)
````
* В инициализационных скриптах недоступта функция to_timestamp (Ограничение SQLPlus)    
(link)[http://shankudada.blogspot.com/2015/07/informatica-oracle-time-stamp-issue.html]