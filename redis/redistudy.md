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
    
    ****需要注意的是redis的事务和mysql的事务是不同的, redis的事务只是保证这一组命令在执行过程中不会被别的客户端的命令打断, 
    如果执行过程中出现了异常的情况并不会回滚而mysql的事务如果在执行过程中出现了异常是会回滚的

    为什么要采用事务? 主要是因为共享数据可能在操作过程中会出现冲突，类似于Java当中的线程安全问题
    一个简单的应用场景：多个线程（事务）对同一个账户进行取款操作
    两种方式对数据进行加锁, 
        1, 悲观锁
            做操作之前加上锁, 执行完释放. 
        2, 乐观锁
            乐观锁操作之前并不会加锁, 更新数据的是够进行判断是否数据发生了改变, 适用于多读的情况, 提高吞吐量, redis就是使用这种check-and-set机制实现的
            使用watch监视一个或者多个key, 如果在执行事务之前这个key发生了改变, 那么事务将会被打断
            unwatch用于取消监视
            如果在执行WATCH命令之后，EXEC命令或DISCARD命令先被执行了的话，那么就不需要再执行UNWATCH了
            
            Redis事务的三特性
            事务单独的隔离操作不会被打断
            事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断
            利用乐观锁解决事务冲突问题
            利用乐观锁机制淘汰同一时间点同一数据的所有操作，只保留最优先提交的任务。实际上就是去除了并发
            不保证原子性
            Redis同一个事务中如果有一条命令执行失败，其后的命令仍然会被执行，没有回滚。
lua 脚本
    Lua是一个小巧的脚本语言，Lua脚本可以很容易的被C/C++代码调用，也可以反过来调用C/C++的函数，Lua并没有提供强大的库，一个完整的Lua解释器不过200k，所以Lua不适合作为开发独立应用程序的语言，
    而是作为嵌入式脚本语言。很多应用程序、游戏使用LUA作为自己的嵌入式脚本语言，以此来实现可配置性、可扩展性。
    这其中包括魔兽争霸地图、魔兽世界、博德之门、愤怒的小鸟等众多游戏插件或外挂. 
    
    LUA脚本在Redis中的优势
      将复杂的或者多步的Redis操作，写为一个脚本，一次提交给Redis执行，减少反复连接Redis的次数。提升性能。
      LUA脚本是类似Redis事务，有一定的原子性，不会被其他命令插队，可以完成一些Redis事务性的操作。
      Redis的Lua脚本功能，只有在2.6以上的版本才可以使用。
redis 持久化问题
    为了避免数据的丢失, redis可以周期性的对数据进行备份(持久化)
    1, RDB redis database
        在指定的时间间隔内将内存中的数据集快照写入磁盘，也就是行话讲的Snapshot快照，它恢复时是将快照文件直接读到内存里。
        Redis会单独创建（fork）一个子进程来进行持久化，会先将数据写入到一个临时文件中，待持久化过程都结束了，再用这个临时文件替换上次持久化好的文件。
        整个过程中，主进程是不进行任何IO操作的，这就确保了极高的性能如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那RDB方式要比AOF方式更加的高效。
        RDB的缺点是最后一次持久化后的数据可能丢失
        在Linux程序中，fork()会产生一个和父进程完全相同的子进程，但子进程在此后多会exec系统调用，出于效率考虑，Linux中引入了“写时复制技术”，
        一般情况父进程和子进程会共用同一段物理内存，只有进程空间的各段的内容要发生变化时，才会将父进程的内容复制一份给子进程
        在redis.conf中配置文件名称，默认为dump.rdb
        rdb文件的保存路径，也可以修改。默认为Redis启动时命令行所在的目录下
        rdb的保存策略   save 900 1 save 300 10 save 60 10000
        save 只负责保存, after 900 seconds if at least 1 key changed after 300 seconds if at least 10 keys changeed after 60 seconds if at least 10000 keys changed
        优点, 节省空间, 恢复速度快, 缺点, 数据两庞大时, 比较小号性能, 如果redis意外down掉, 就会丢失最后一次备份之后的数据
    2,AOF APPEND OF FILE
        以日志的形式来记录每个写操作，将Redis执行过的所有写指令记录下来(读操作不记录)，
        只许追加文件但不可以改写文件，Redis启动之初会读取该文件重新构建数据，换言之，Redis重启的话就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作
        AOF 默认不开启
          需要手动配置
            appendonly no
            appendfilename ""
          aof 和rdb同时开启, 系统默认取AOF的数据
          AOF文件故障恢复 : AOF文件的保存路径，同RDB的路径一致, 如遇到AOF文件损坏，可通过 redis-check-aof --fix appendonly.aof 进行恢复
          AOF 同步频率
              appendfsync everysec (每一秒) always 每一次写操作就同步, 不主动进行同步, 把同步时机交给系统 no
        AOF 重写
            aof 文件过大, fork一个新的进程将文件重写, 重写aof文件并不会读取久的aof文件, 而是讲整个内存中的数据库内容重写为一个新的aof文件
            每次重写还是有一定的负担的
            系统载入时或者上次重写完毕时，Redis会记录此时AOF大小，设为base_size,如果Redis的AOF当前大小>= base_size +base_size*100% (默认)
            且当前大小>=64mb(默认)的情况下，Redis会对AOF进行重写
            auto-aof-rewrite-percentage  100
            auto-aof-rewrite-min-size  64mb
            优点: 
                备份机制更稳健，丢失数据概率更低, 可读的日志文本，通过操作AOF稳健，可以处理误操作
            缺点: 
                比起RDB占用更多的磁盘空间, 恢复备份速度要慢, 每次读写都同步的话，有一定的性能压力, 存在个别Bug，造成恢复不能
        哪一种持久化更好呢？
            官方推荐两个都启用
            如果对数据不敏感，可以选单独用RDB
            不建议单独用 AOF，因为可能会出现Bug
            如果只是做纯内存缓存，可以都不用
redis的主从复制
        一般为了防止数据丢失或设备单点故障，会为当前设备（主）增加其他设备作为备份（从）。
        主从复制，就是主机数据更新后根据配置和策略，自动同步到备机的master/slaver机制，Master以写为主，Slave以读为主
        用处: 读写分离，性能扩展，容灾快速恢复
        主从复制原理
            1, 从机联通后给主机发送sync命令
            2, 主机进行存盘操作, 发送rdb文件给从机
            3, 从机收到进行加载
            4, 之后每次主机进行写操作, 同步命令到从机
        机制: 
            上一个slave可以是下一个slave的master, slave可以接受其他slave的链接和同步请求, 这个slave作为链条中的下一个master, 可以减轻master的压力
            使用slaveof <ip> <port>
            中途变更转向会清除之前的数据,重新建立拷贝最新的
            风险是一旦一个slave宕机, 后面的slave都没法备份
            master ---> slave ----> slave
            当master宕机后后面的slave就会升级为master, 使用slaveof no one 将从机变成主机
        主从复制哨兵机制: 
            后台监控主机是否故障, 如果故障了根据投票数自动将从机变为主机
            调整为一主二从模式
						自定义的/myredis目录下新建sentinel.conf文件
						在配置文件中填写内容：sentinel monitor mymaster 127.0.0.1 6379 1
						其中mymaster为监控对象起的服务器名称， 1 为 至少有多少个哨兵同意迁移的数量
						启动哨兵，执行redis-sentinel /myredis/sentinel.conf<Paste>
redis 集群
		  Redis集群实现了对Redis的水平扩容, 即启动N个Redis节点, 将整个数据库分布存储在这N个节点中, 每个节点存储总数据的1/N
			Redis集群通过分区(partition)来提供一定程度的可用性(availability):  即使集群中有一部分节点失效或者无法进行通讯,  集群也可以继续处理命令请求
			
			安装ruby环境, 依次执行在安装光盘下的Package目录(/media/CentOS_6.8_Final/Packages)下的rpm包
      		执行rpm -ivh compat-readline5-5.2-17.1.el6.x86_64.rpm
      		执行rpm -ivh ruby-libs-1.8.7.374-4.el6_6.x86_64.rpm
      		执行rpm -ivh ruby-1.8.7.374-4.el6_6.x86_64.rpm
      		执行rpm -ivh ruby-irb-1.8.7.374-4.el6_6.x86_64.rpm
      		执行rpm -ivh ruby-rdoc-1.8.7.374-4.el6_6.x86_64.rpm
      		执行rpm -ivh rubygems-1.3.7-5.el6.noarch.rpm
      拷贝redis-3.2.0.gem到/opt目录下
      在opt目录下执行 gem install --local redis-3.2.0.gem
      制作6个实例, 6379,6380,6381,6389,6390,6391
					拷贝多个redis.conf文件
					开启daemonize yes
					pid文件名字
					制定端口
					LOg文件名字
					Dump.rdb 名字
					Appendonly 关掉或者换名字
			安装redis cluster配置修改
					cluster-enabled yes 打开集群模式
      		cluster-config-file nodes-6379.conf 设定节点配置文件名
      		cluster-node-timeout 15000 设定节点失联时间, 超过该时间(毫秒), 集群自动进行主从切换
			将六个节点合成一个集群
		      组合之前, 请确保所有redis实例启动后, nodes-xxxx.conf文件都生成正常
    		  cd /opt/redis-3.2.5/src
      		./redis-trib.rb create --replicas 1 192.168.31.211:6379 192.168.31.211:6380 192.168.31.211:6381 192.168.31.211:6389 192.168.31.211:6390 192.168.31.211:6391
					(此处不要用127.0.0.1,  请用真实IP地址)
			通过 cluster nodes 命令查看集群信息
			redis cluster 分配这六个节点
      		一个集群至少要有三个主节点
      		选项 --replicas 1 表示我们希望为集群中的每个主节点创建一个从节点
      		分配原则尽量保证每个主数据库运行在不同的IP地址, 每个从库和主库不在一个IP地址上
			在集群中录入值
					在redis-cli每次录入\ 查询键值, redis都会计算出该key应该送往的插槽, 如果不是该客户端对应服务器的插槽, redis会报错, 并告知应前往的redis实例地址和端口
          redis-cli客户端提供了 –c 参数实现自动重定向. 如 redis-cli -c –p 6379 登入后, 再录入\ 查询键值对可以自动重定向. 
          不在一个slot下的键值, 是不能使用mget,mset等多键操作
          可以通过{}来定义组的概念, 从而使key中{}内相同内容的键值对放到一个slot中去
			查询集群中的值
		      CLUSTER KEYSLOT  计算键 key 应该被放置在哪个槽上
    		  CLUSTER COUNTKEYSINSLOT  返回槽 slot 目前包含的键值对数量. 
      		CLUSTER GETKEYSINSLOT   返回 count 个 slot 槽中的键
			故障恢复
					如果主节点下限? 从节点能否自动升为主节点? 
          主节点恢复后, 主从关系会如何? 
          如果所有某一段插槽的主从节点都当掉, redis服务是否还能继续?
          redis.conf中的参数 cluster-require-full-coverage
			优点：
					实现扩容
          分摊压力
          无中心配置相对简单
			缺点：
					多键操作是不被支持的
          多键的Redis事务是不被支持的. lua脚本不被支持
          由于集群方案出现较晚, 很多公司已经采用了其他的集群方案, 而代理或者客户端分片的方案想要迁移至redis cluster, 需要整体迁移而不是逐步过渡, 复杂度较大


























