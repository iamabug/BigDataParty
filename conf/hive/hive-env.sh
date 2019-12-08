export HADOOP_HOME=/usr/local/hadoop
export HIVE_CONF_DIR=/etc/hive
export TEZ_HOME=/usr/local/tez
export TEZ_CONF_DIR=/etc/tez
export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*