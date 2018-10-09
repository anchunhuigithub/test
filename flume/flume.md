                          flume study
1,  flume 监控
    参考文件地址    http://lxw1234.com/archives/2018/02/899.htm
    一共有4种Reporting方式，JMX Reporting、Ganglia Reporting、JSON Reporting、Custom Reporting， 这里以最简单的JSON Reporting为例。
    在启动Flume Agent时候，增加两个参数：
    flume-ng agent -n agent_lxw1234 –conf . -f agent_lxw1234_file_2_kafka.properties -Dflume.monitoring.type=http -Dflume.monitoring.port=34545
    flume.monitoring.type=http 指定了Reporting的方式为http，flume.monitoring.port 指定了http服务的端口号。
    启动后，会在Flume Agent所在的机器上启动http服务，http://<hostname>:34545/metrics 打开该地址后，返回一段JSON：
        {
        "SINK.sink_lxw1234":{
            "ConnectionCreatedCount":"0",
            "BatchCompleteCount":"0",
            "BatchEmptyCount":"72",
            "EventDrainAttemptCount":"0",
            "StartTime":"1518400034824",
            "BatchUnderflowCount":"43",
            "ConnectionFailedCount":"0",
            "ConnectionClosedCount":"0",
            "Type":"SINK",
            "RollbackCount":"0",
            "EventDrainSuccessCount":"244",
            "KafkaEventSendTimer":"531",
            "StopTime":"0"
        },
        "CHANNEL.file_channel_lxw1234":{
            "Unhealthy":"0",
            "ChannelSize":"0",
            "EventTakeAttemptCount":"359",
            "StartTime":"1518400034141",
            "Open":"true",
            "CheckpointWriteErrorCount":"0",
            "ChannelCapacity":"10000",
            "ChannelFillPercentage":"0.0",
            "EventTakeErrorCount":"0",
            "Type":"CHANNEL",
            "EventTakeSuccessCount":"244",
            "Closed":"0",
            "CheckpointBackupWriteErrorCount":"0",
            "EventPutAttemptCount":"244",
            "EventPutSuccessCount":"244",
            "EventPutErrorCount":"0",
            "StopTime":"0"
        },
        "SOURCE.source_lxw1234":{
            "EventReceivedCount":"244",
            "AppendBatchAcceptedCount":"45",
            "Type":"SOURCE",
            "AppendReceivedCount":"0",
            "EventAcceptedCount":"244",
            "StartTime":"1518400034767",
            "AppendAcceptedCount":"0",
            "OpenConnectionCount":"0",
            "AppendBatchReceivedCount":"45",
            "StopTime":"0"
        }
       }
2,  flume 拦截器 interceptor
        参考文档: http://lxw1234.com/archives/2015/11/543.htm  http://lxw1234.com/archives/2015/11/545.htm
        Flume中的拦截器（interceptor），用户Source读取events发送到Sink的时候，在events header中加入一些有用的信息，或者对events的内容进行过滤，
            完成初步的数据清洗。这在实际业务场景中非常有用，Flume-ng 1.6中目前提供了以下拦截器：
        Timestamp Interceptor；
        Host Interceptor；
        Static Interceptor；
        UUID Interceptor；
        Morphline Interceptor；
        Search and Replace Interceptor；
          该拦截器为查找和替换 使用正则表达式进行查找 type=search_replace serachPattern =[0-9]+ replaceString=abc 把数字替换为 abc
        Regex Filtering Interceptor；
          过滤拦截器  type=regex_filter  regex=^abc.* execludeEvents=false 代表过滤掉不是以abc开头的 event数据
        Regex Extractor Interceptor；
          该拦截器使用正则表达式抽取原始events中的内容，并将该内容加入events header中。
          type = regex_extractor regex = cookieid is (.*?) and ip is (.*?)           
3,  flume 1.6 使用 kafka sink 出现的问题
       cpu使用率过高问题  flume1.6 自带的问题
       发现该问题在Flume1.7中fix掉了，接着找到github中Flume1.7的代码，具体就是：
       https://github.com/apache/flume/blob/trunk/flume-ng-sinks/flume-ng-kafka-sink/src/main/java/org/apache/flume/sink/kafka/KafkaSink.java
       使用该代码编译后替换掉flume-ng-kafka-sink-1.6.0.jar中的KafkaSink.class，重启Flume Agent之后，问题解决。
4,    利用Flume拦截器（interceptors）实现Kafka Sink的自定义规则多分区写入
        ref  http://lxw1234.com/archives/2015/11/547.htm


