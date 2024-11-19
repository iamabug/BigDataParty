#FROM gethue/hue
FROM ubuntu:24.04

# add all packages
ADD packages/*gz /usr/local/

RUN sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources

# set mysql password without prompt
RUN apt-get update && apt-get install -y debconf-utils apt-utils && \
echo mysql-server-8.0 mysql-server/root_password password root | debconf-set-selections && \
echo mysql-server-8.0 mysql-server/root_password_again password root | debconf-set-selections && \
apt-get install -y mysql-server-8.0 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends build-essential gcc openjdk-8-jdk net-tools vim wget telnet iputils-ping
RUN apt-get install -y --no-install-recommends openssh-server openssh-client python3 python3-dev python3-pip tzdata
RUN wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.1.0/mysql-connector-j-9.1.0.jar -O /usr/share/java/mysql-connector-java.jar
RUN rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "Asia/Shanghai" > /etc/timezone && \
rm -f /etc/localtime  && \
dpkg-reconfigure -f noninteractive tzdata

# zookeeper
RUN mv /usr/local/apache-zookeeper-* /usr/local/zookeeper
RUN mkdir /var/lib/zookeeper
RUN sed "s#/tmp/zookeeper#/var/lib/zookeeper#" /usr/local/zookeeper/conf/zoo_sample.cfg > /usr/local/zookeeper/conf/zoo.cfg


# hadoop
RUN mv /usr/local/hadoop-* /usr/local/hadoop
RUN ln -s /usr/local/hadoop/etc/hadoop /etc/hadoop
RUN mkdir -p /usr/local/hadoop/data/{namenode,datanode} /etc/hadoop-httpfs/conf/

RUN echo "\nStrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN useradd -m hadoop
#RUN useradd --ingroup hadoop --quiet --disabled-password hadoop
RUN echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN su hadoop -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys"
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/hadoop/hadoop-env.sh
RUN echo "bigdata" > /etc/hadoop/workers
RUN chown -R hadoop:hadoop /usr/local/hadoop


ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV HADOOP_MAPRED_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_HOME=${HADOOP_HOME}
ENV HADOOP_HDFS_HOME=${HADOOP_HOME}
ENV YARN_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
ENV HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib"
#ENV PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH
ADD conf/hadoop /etc/hadoop
ADD conf/httpfs/httpfs-site.xml /etc/hadoop-httpfs/conf/

# Spark
RUN mv /usr/local/spark-* /usr/local/spark && \
ln -s /usr/local/spark/conf /etc/spark
ADD conf/spark /etc/spark
RUN cp /usr/local/spark/conf/log4j2.properties.template /usr/local/spark/conf/log4j2.properties
RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/local/spark/jars/mysql-connector-java.jar
RUN ln -s /usr/local/hive/conf/hive-site.xml /usr/local/spark/conf/hive-site.xml
RUN sed -i 's/rootLogger.level=info/rootLogger.level=warn/' /usr/local/spark/conf/log4j2.properties

# Kafka
RUN mv /usr/local/kafka_* /usr/local/kafka && \
ln -s /usr/local/kafka/config /etc/kafka
ADD conf/kafka/server.properties /etc/kafka
RUN mkdir /usr/local/kafka/data /usr/local/kafka/log

# Tez
RUN mv /usr/local/apache-tez-* /usr/local/tez && \
ln -s /usr/local/tez/conf /etc/tez
ENV TEZ_HOME=/usr/local/tez

# Hive
RUN mv /usr/local/apache-hive-* /usr/local/hive && \
ln -s /usr/local/hive/conf /etc/hive
ADD conf/hive /etc/hive
RUN ln -s /usr/share/java/mysql-connector-java.jar  /usr/local/hive/lib/mysql-connector-java.jar
RUN rm /usr/local/hive/lib/guava-*.jar
RUN cp /usr/local/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /usr/local/hive/lib
ENV HIVE_HOME=/usr/local/hive
ENV HIVE_CONF_DIR=/etc/hive
RUN chown -R hadoop:hadoop /usr/local/hive

# Hue
#ADD conf/hue /usr/share/hue/desktop/conf

# MySQL
RUN chown -R mysql:mysql /var/lib/mysql

# Flink
RUN mv /usr/local/flink-* /usr/local/flink
ADD packages/flink-hadoop-uber.jar /usr/local/flink/lib/

# PATH
ENV PATH=/usr/local/flink/bin:/usr/local/spark/bin:/usr/local/hive/bin:/usr/local/kafka/bin:/usr/local/hadoop/bin/:/usr/local/hadoop/sbin:$PATH
RUN echo "PATH=/usr/local/flink/bin:/usr/local/spark/bin:/usr/local/hive/bin:/usr/local/kafka/bin:/usr/local/hadoop/bin/:/usr/local/hadoop/sbin:$PATH" >> /etc/environment

# involved scripts
ADD scripts/* /run/

WORKDIR /

CMD ["bash", "-c", "/run/entrypoint.sh && /run/wait_to_die.sh"]
