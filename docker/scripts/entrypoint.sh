#!/usr/bin/env bash

# ssh
service ssh start

# mysql
chown -R mysql:mysql /var/lib/mysql
service mysql start
/run/mysql_init.sh

# zookeeper
/usr/local/zookeeper/bin/zkServer.sh start

# kafka
nohup kafka-server-start.sh /etc/kafka/server.properties > /usr/local/kafka/log/kafka.log 2>&1 &

# hadoop
su hadoop -c "bash /run/hadoop_init.sh"

# hive
su hadoop -c "bash /run/hive_start.sh"


# hue
/usr/share/hue/build/env/bin/hue syncdb --noinput
/usr/share/hue/build/env/bin/hue migrate
nohup /usr/share/hue/build/env/bin/supervisor > /dev/null 2>&1 &


# temporary
#while true; do sleep 1000; done
