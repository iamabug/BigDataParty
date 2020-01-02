#!/usr/bin/env bash

hadoop_v=3.1.3
spark_v=2.4.4
zookeeper_v=3.5.6
kafka_v=2.3.1
scala_v=2.11
hive_v=3.1.2
tez_v=0.9.2
flink_v=1.9.1

# font color
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

mirror_prefix="http://mirrors.tuna.tsinghua.edu.cn"
hadoop_url=${mirror_prefix}/apache/hadoop/common/hadoop-${hadoop_v}/hadoop-${hadoop_v}.tar.gz
spark_url=${mirror_prefix}/apache/spark/spark-${spark_v}/spark-${spark_v}-bin-hadoop2.7.tgz
zookeeper_url=${mirror_prefix}/apache/zookeeper/zookeeper-${zookeeper_v}/apache-zookeeper-${zookeeper_v}-bin.tar.gz
kafka_url=${mirror_prefix}/apache/kafka/2.3.1/kafka_${scala_v}-${kafka_v}.tgz
hive_url=${mirror_prefix}/apache/hive/hive-${hive_v}/apache-hive-${hive_v}-bin.tar.gz
tez_url=${mirror_prefix}/apache/tez/${tez_v}/apache-tez-${tez_v}-bin.tar.gz
flink_url=${mirror_prefix}/apache/flink/flink-${flink_v}/flink-${flink_v}-bin-scala_${scala_v}.tgz
flink_required_jar="https://repo.maven.apache.org/maven2/org/apache/flink/flink-shaded-hadoop-2-uber/2.8.3-7.0/flink-shaded-hadoop-2-uber-2.8.3-7.0.jar"

colorful_echo() {
    echo "${1}${2}${NC}"
}
download() {
    if [ -f "packages/$2" ]; then
        colorful_echo ${RED} "$2 already exits, skip it.\n"
    else
        colorful_echo ${GREEN} "Start downloading $2 from $1 ...\n"
        wget $1 -O "packages/$2" > /dev/null 2>&1
        colorful_echo ${BLUE} "$2 downloaded successfully.\n"
    fi
}

download "${hadoop_url}" hadoop.tar.gz
download "${spark_url}" spark.tgz
download "${zookeeper_url}" zookeeper.tar.gz
download "${kafka_url}" kafka.tgz
download "${hive_url}" hive.tar.gz
download "${tez_url}" tez.tar.gz
download "${flink_url}" flink.tgz
download "${flink_required_jar}" flink-hadoop-uber.jar

docker build -t bdp .
