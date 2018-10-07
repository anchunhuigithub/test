redis
安装 wget http://download.redis.io/releases/redis-4.0.11.tar.gz
     tar xzf redis-4.0.11.tar.gz
     cd redis-4.0.11
     make
启动
     $REDIS_HOME/src/redis_server $REDIS_HOME/redis.conf
配置redis服务端口以及redis的运行方式
     更改redis.conf 文件中的 port 6000
     更改 daemonize 为yes
redis 操作
     链接redis $REDIS_HOME/redis_cli -h host -p port -a password
     有时候reids 会中文乱码使用 redis_cli --raw 可以避免乱码
redis 超时时间设置
     EXPIRE key seconds
     为给定的key的生存时间,当key过期时(生存时间为0), 将会被自动删除
     生存时间可以通过del命令来移除, 或者被set命令覆盖, 如果一个命令只是修改了一个带有生存时间的key的值,
     而不是用一个新key来替换他的话, 那么生存时间不会改变. 比如对一个key进行incr命令, 对一个列表进行lpush, 这类操作不会修改key的本身的生存时间
     另外, 对一个key进行rename的操作的话, 那么改名后的key具有相同的生存时间
     rename的另外的一个含义为: 更改一个key为另外一个含有生存时间的key, 那么旧的key以及他的生存时间将会被删除, 新的key将会有和之前一样的生存时间.
     可以对一个已经具有生存时间的key使用expire命令重新制定生存时间. 
     ttl key 查看key的剩余生存时间, 返回-2 表示不存在key 返回-1 表示剩余时间不足
redis学习网站:      http://www.redis.net.cn/order/3685.html
redis 数据结构
     string: 最基本的数据结构  get<key> set<key> <value>
     list: 双向连表 lpush/rpush <key> <value1> <value2> 从左边或者右侧插入数据 lpop/rpop 从左边或者右侧推出一个zhi. 
     set: 不重复, 一个key, 多个value. 
     zset: score 有序
     hash: key field value一个key包含了多个field和value 效率高 o(1)
redis 事务 
    事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。
    Redis事务的主要作用就是串联多个命令防止别的命令插队
    从输入Multi命令开始，输入的命令都会依次进入命令队列中，但不会执行，至到输入Exec后，Redis会将之前的命令队列中的命令依次执行。
    组队的过程中可以通过discard来放弃组队。
    如果组队中某个命令出现了报告错误，执行时整个队列中所有命令都会被取消。
    如果执行中某个命令出现了报告错误，则只有报错的命令不会被执行，而其他的命令都会执行，不会回滚。

