#!/usr/bin/env bash
#/usr/local/zookeeper/bin/zkServer.sh start

service ssh start
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/etc/hadoop
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib"
su hadoop -c "hadoop namenode -format && start-all.sh"
#echo "export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}" >> /home/hadoop/.bashrc

# temporary
#while true; do sleep 1000; done
