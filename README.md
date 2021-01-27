# BigDataParty

大数据组件 All-in-One 的 Dockerfile。

## 1. 基本信息

各个组件的版本信息如下（MySQL的 root 密码为 root）：

|     组件      |     版本     |
| :-----------: | :----------: |
|   基础镜像    | ubuntu:18.04 |
|    Hadoop     |    3.1.4     |
|     Spark     |    2.4.4     |
| Hive (on Tez) |    3.1.2     |
|      Tez      |    0.9.2     |
|      Hue      |    4.5.0     |
|     Flink     |    1.9.1     |
|   Zookeeper   |    3.5.6     |
|     Kafka     |    2.3.1     |
|     MySQL     |     5.7      |

## 2. 启动说明

镜像已经推送到Docker Hub，直接执行如下命令应当会开始拉取镜像：

```
docker run -it -p 8088:8088 -p 8888:8888 -h bigdata iamabug1128/bdp bash
```

或者 clone 本项目并执行 `run-bdp.sh` 脚本。

> 8088 是 YARN 的 Web UI 端口，8888 是 Hue 的端口。
>
> 主机名必须指定为 bigdata。

进入镜像后，启动所有组件的命令：

```
/run/entrypoint.sh
```

或者，单独启动 Kafka：

```bash
/run/start_kafka.sh
```

查看进程，确认所有进程都已经启动：

```bash
root@bigdata:/# jps
1796 ResourceManager
1316 DataNode
2661 RunJar
1205 NameNode
2662 RunJar
3719 Jps
1914 NodeManager
1530 SecondaryNameNode
523 QuorumPeerMain
543 Kafka
```

除了 Hue 安装在 `/usr/share/hue` 、MySQL 安装在系统路径以外，其它所有的组件的安装在 `/usr/local/` 目录下：

```bash
root@bigdata:/# ls /usr/local/      
bin  etc  flink  games  hadoop  hive  include  kafka  lib  man  sbin  share  spark  src  tez  zookeeper
```

## 3. 使用示例

### 3.1 使用 Hue 上传文件到 HDFS

访问 `localhost:8888` ，输入 `admin, admin` 登录 Hue，点击左侧 `Files` 导航按钮，出现文件浏览器页面：

![](https://tva1.sinaimg.cn/large/006tNbRwly1g9rj4l1p6jj32l60jqafp.jpg)

点击右上角的 `Upload` 按钮，选择一个文件上传，上传后页面：

![](https://tva1.sinaimg.cn/large/006tNbRwly1g9rj9tqq8qj31fc0b83zp.jpg)

回到容器的命令行中，查看 `/user/admin` 目录：

![](https://tva1.sinaimg.cn/large/006tNbRwly1g9rjbu571mj31dg08mn2d.jpg)

说明上传确实成功了。

### 3.2 运行 Flink on Yarn 的 WordCount 例子

在命令行中切换到 `/usr/local/flink` 目录，执行 `./bin/flink run -m yarn-cluster -p 4 -yjm 1024m -ytm 4096m ./examples/batch/WordCount.jar`：

![](https://tva1.sinaimg.cn/large/006tNbRwly1g9rjqylh15j32ia0qunpd.jpg)

在浏览器中打开 `http://localhost:8088`，可以看到正在执行的 Flink 任务：

![](https://tva1.sinaimg.cn/large/006tNbRwly1g9rjp3xjjoj327e0e2jv8.jpg)

任务顺利完成：

![](https://tva1.sinaimg.cn/large/006tNbRwly1g9rjsiqu1qj318a0hagxq.jpg)

## 4. 构建说明

目录结构如下：

```bash
BigDataParty $ tree               
.
├── Dockerfile
├── README.md
├── build.sh
├── conf
├── packages
├── run-bdp.sh
└── scripts
```

除了 README 和 Dockerfile 各文件目录简介如下：

* build.sh：下载各组件的压缩包并执行 `docker build`
* run-bdp.sh：运行构建好的镜像，并暴露 Hue 和 Yarn 的 Web 端口
* conf：存放各个组件的配置文件，构建镜像时拷贝到各组件的目录下
* packages：存放各个组件的压缩包，构建镜像时解压到 `/usr/local` 目录下
* scripts：存放各个组件初始化和启动脚本，构建镜像时拷贝到 `/run` 目录下

## 5. 待续

写这个镜像的目的是为了方便自己平时使用（学习、测试、验证等等），以后还会继续完善，如果你有兴趣，欢迎加入我。


