#/usr/bin/env bash

schematool -initSchema -dbType mysql
nohup hive --service metastore > /dev/null 2>&1 &
nohup hive --service hiveserver2 > /dev/null 2>&1 &