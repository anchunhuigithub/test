  zookeeper 学习笔记
1,zookeeper  安装配置
  三个节点
    dn1,dn2,dn3
    $ZOOKEEPER/conf/zoo.cfg 文件中 添加 
    server.1=dn1:2888:3888
    server.2=dn2:2888:3888
    server.3=dn3:2888:3888
    dataDir=$ZOOKEEPER/data  只配置这个dataDir 那么snapshot和transaction log 都会写道这个目录的version2下
    建议配置dataLogDir 指定了transaction log的目录地址 不要和dataDir放到一起

  
    

    
    
    mkidr $ZOOKEEPRE/data
    在对应的节点的zookeeper的data目录在创建名称为myid的文件对应文件中写入对应的id号码dn1 的为1 dn2的为2 dn3 的为3
    

