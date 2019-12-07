#!/usr/bin/env bash

# 初始化
hadoop namenode -format && start-all.sh

# 创建 hive 目录
hdfs dfs -mkdir -p /user/hive/warehouse /user/hive/tmp /user/hive/log
hdfs dfs -chmod 777 /user/hive/warehouse /user/hive/tmp /user/hive/log
