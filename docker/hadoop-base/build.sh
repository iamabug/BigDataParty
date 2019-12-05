hadoop_v=3.1.3
spark_v=2.4.4
zookeeper_v=3.5.6

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

mirror_prefix=http://mirrors.tuna.tsinghua.edu.cn
hadoop_url=${mirror_prefix}/apache/hadoop/common/hadoop-"${hadoop_v}"/hadoop-"${hadoop_v}".tar.gz
spark_url=${mirror_prefix}/apache/spark/spark-"${spark_v}"/spark-${spark_v}-bin-hadoop2.7.tgz
zookeeper_url=${mirror_prefix}/apache/zookeeper/zookeeper-"${zookeeper_v}"/apache-zookeeper-"${zookeeper_v}"-bin.tar.gz

colorful_echo() {
    echo "${1}${2}${NC}"
}
download() {
    if [ -f "$2" ]; then
        colorful_echo ${RED} "$2 already exits, skip it.\n"
    else
        colorful_echo ${GREEN} "Start downloading $2 from $1 ...\n"
        wget $1 -O $2 > /dev/null 2>&1
        colorful_echo ${BLUE} "$2 downloaded successfully.\n"
    fi
}

download "${hadoop_url}" hadoop.tar.gz
download "${spark_url}" spark.tgz
download "${zookeeper_url}" zookeeper.tar.gz
