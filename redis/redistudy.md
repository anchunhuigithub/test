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
