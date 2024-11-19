#!/usr/bin/env bash

hadoop_v=3.4.1
spark_v=3.5.3
zookeeper_v=3.8.4
kafka_v=3.9.0
scala_v=2.13
hive_v=4.0.1
tez_v=0.10.4
flink_v=1.20.0

# font color
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

mirror_prefix="http://mirrors.tuna.tsinghua.edu.cn"
hadoop_url=${mirror_prefix}/apache/hadoop/common/hadoop-${hadoop_v}/hadoop-${hadoop_v}.tar.gz
spark_url=${mirror_prefix}/apache/spark/spark-${spark_v}/spark-${spark_v}-bin-hadoop3.tgz
zookeeper_url=${mirror_prefix}/apache/zookeeper/zookeeper-${zookeeper_v}/apache-zookeeper-${zookeeper_v}-bin.tar.gz
kafka_url=${mirror_prefix}/apache/kafka/${kafka_v}/kafka_${scala_v}-${kafka_v}.tgz
hive_url=${mirror_prefix}/apache/hive/hive-${hive_v}/apache-hive-${hive_v}-bin.tar.gz
#tez_url=${mirror_prefix}/apache/tez/${tez_v}/apache-tez-${tez_v}-bin.tar.gz
flink_url=${mirror_prefix}/apache/flink/flink-${flink_v}/flink-${flink_v}-bin-scala_2.12.tgz
#flink_required_jar="https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/2.8.3-7.0/flink-shaded-hadoop-2-uber-2.8.3-7.0.jar"
flink_required_jar="https://repository.cloudera.com/artifactory/cloudera-repos/org/apache/flink/flink-shaded-hadoop-3-uber/3.1.1.7.2.9.0-173-9.0/flink-shaded-hadoop-3-uber-3.1.1.7.2.9.0-173-9.0.jar"

colorful_echo() {
    echo "${1}${2}${NC}"
}
download() {
    if [ -f "packages/$2" ]; then
        colorful_echo ${RED} "$2 already exits, skip it.\n"
    else
        colorful_echo ${GREEN} "Start downloading $2 from $1 ...\n"
        wget $1 -O "packages/$2"
        colorful_echo ${BLUE} "$2 downloaded successfully.\n"
    fi
}

download "${hadoop_url}" hadoop.tar.gz
download "${spark_url}" spark.tgz
download "${zookeeper_url}" zookeeper.tar.gz
download "${kafka_url}" kafka.tgz
download "${hive_url}" hive.tar.gz
#download "${tez_url}" tez.tar.gz
download "${flink_url}" flink.tgz
download "${flink_required_jar}" flink-hadoop-uber.jar

docker build -t iamabug1128/bdp .
