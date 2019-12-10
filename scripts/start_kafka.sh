#!/usr/bin/env bash

# zookeeper
/usr/local/zookeeper/bin/zkServer.sh start

# kafka
nohup kafka-server-start.sh /etc/kafka/server.properties > /usr/local/kafka/log/kafka.log 2>&1 &