#!/usr/bin/env bash

# 初始化
hadoop namenode -format && start-all.sh

# 创建 hive 目录
hadoop fs -mkdir -p /user/hive/warehouse /user/hive/tmp /user/hive/log /user/tez /user/root
hadoop fs -chown root /user/root
hadoop fs -chmod 777 /user/hive/warehouse /user/hive/tmp /user/hive/log
hadoop fs -put /usr/local/tez/share/tez.tar.gz /user/tez/
