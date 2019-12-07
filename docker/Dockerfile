FROM ubuntu:18.04

RUN sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# set mysql password without prompt
RUN apt-get update && apt-get install -y debconf-utils apt-utils && \
echo mysql-server-5.7 mysql-server/root_password password root | debconf-set-selections && \
echo mysql-server-5.7 mysql-server/root_password_again password root | debconf-set-selections && \
apt-get install -y mysql-server-5.7 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing

RUN apt-get install -y --no-install-recommends openjdk-8-jdk net-tools vim wget telnet iputils-ping \
openssh-server openssh-client python3 python3-dev python3-pip libmysql-java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64


# add all packages
ADD packages/* /usr/local/
RUN ls /usr/local

# zookeeper
RUN mv /usr/local/apache-zookeeper* /usr/local/zookeeper
RUN mkdir /var/lib/zookeeper
RUN sed "s#/tmp/zookeeper#/var/lib/zookeeper#" /usr/local/zookeeper/conf/zoo_sample.cfg > /usr/local/zookeeper/conf/zoo.cfg


# hadoop
RUN mv /usr/local/hadoop* /usr/local/hadoop
RUN ln -s /usr/local/hadoop/etc/hadoop /etc/hadoop
RUN mkdir -p /usr/local/hadoop/data/{namenode,datanode}

RUN echo "\nStrictHostKeyChecking no\nUserKnownHostsFile" >> /etc/ssh/ssh_config && \
addgroup hadoop && \
adduser --ingroup hadoop --quiet --disabled-password hadoop && \
echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
su hadoop -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys" && \
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/hadoop/hadoop-env.sh && \
echo "bigdata" > /etc/hadoop/workers && \
chown -R hadoop:hadoop /usr/local/hadoop


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

# Spark
RUN mv /usr/local/spark* /usr/local/spark && \
ln -s /usr/local/spark/conf /etc/spark
ADD conf/spark /etc/spark
#ENV PATH=/usr/local/spark/bin:$PATH

# Kafka
RUN mv /usr/local/kafka* /usr/local/kafka && \
ln -s /usr/local/kafka/config /etc/kafka
ADD conf/kafka/server.properties /etc/kafka
RUN mkdir /usr/local/kafka/data /usr/local/kafka/log
#ENV PATH=/usr/local/kafka/bin:$PATH

# Hive
RUN mv /usr/local/apache-hive* /usr/local/hive && \
ln -s /usr/local/hive/conf /etc/hive
ADD conf/hive /etc/hive
RUN ln -s /usr/share/java/mysql-connector-java.jar  /usr/local/hive/lib/mysql-connector-java.jar
RUN rm /usr/local/hive/lib/guava-19.0.jar
RUN cp /usr/local/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /usr/local/hive/lib
ENV HIVE_HOME=/usr/local/hive
ENV HIVE_CONF_DIR=/etc/hive


# MySQL
RUN chown -R mysql:mysql /var/lib/mysql

# PATH
ENV PATH=/usr/local/hive/bin:/usr/local/kafka/bin:/usr/local/hadoop/bin/:/usr/local/hadoop/sbin:$PATH
RUN echo "PATH=/usr/local/hive/bin:/usr/local/kafka/bin:/usr/local/hadoop/bin/:/usr/local/hadoop/sbin:$PATH" >> /etc/environment
# all
ADD scripts/* /run/

#ENTRYPOINT ["bash", "-c", "/tmp/start_all.sh"]
