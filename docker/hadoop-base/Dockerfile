FROM ubuntu:18.04

RUN sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-8-jdk net-tools vim wget telnet iputils-ping
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64


# zookeeper
ADD zookeeper.tar.gz /usr/local
RUN mv /usr/local/apache-zookeeper* /usr/local/zookeeper
RUN mkdir /var/lib/zookeeper
RUN sed "s#/tmp/zookeeper#/var/lib/zookeeper#" /usr/local/zookeeper/conf/zoo_sample.cfg > /usr/local/zookeeper/conf/zoo.cfg


# hadoop
#ADD hadoop.tar.gz /usr/local
#RUN ls /usr/local
#RUN mv /usr/local/hadoop* /usr/local/hadoop
#RUN ln -s /usr/local/hadoop/etc/hadoop /etc/hadoop
#RUN mkdir /usr/local/hadoop/logs /hadoop-data

ENV HADOOP_PREFIX=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV PATH="${HADOOP_PREFIX}"/bin:"${PATH}"
ENV USER=root

ADD start_all.sh /tmp/

ENTRYPOINT ["bash", "-c", "/tmp/start_all.sh"]
