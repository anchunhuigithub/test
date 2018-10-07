spark 学习笔记
1, spark version 1.6.2   scala version 2.10.5
    example:
        wordcount sc.textFile("path").flatMap(line=>line.split(" ")).map((_,1)).reduceByKey(_+_).sortBy(_.2,false).saveAsTextFile("path") 
2,scala 语法总结
    1,scala 变量
    2,if while 
    3,class
    4,abstract class
        类的一个或者多个方法没有完整的定义
        声明抽象方法不需要使用abstract 关键字, 只需要不写方法体
        子类重写父类抽象方法时不需要加override关键字
        父类可以声明抽象字段(没有初始值字段)
        子类重写父类的抽象字段时不需要加override
        abstract class Person3{
            def spark
            val name:String
            var age:Int
        }
        class Student extends Person3{
            def spark:Unit={
                println("spark!!!")
            }
            val name="AAA"
            var age=100
        }
    5,Trait
        当中接口
        带有具体实现的接口
        带有特质的对象
        特质从左到右被构造
    6,Object
        scala 本身没有静态的方法和变量
        可以使用Object 进行实现
        Object 中的方法和变量就是静态的, 可以直接调用
    7,
3,sortby
    自定义比较器
    场景: 按照第二个元素进行倒叙排列,如果第二个元素相同, 按照第一个元素进行正序排列,
    val mysort=new Ordering[Tuple2[String,Int]]{
        override def compare(x:(String,Int),y:(String,Int)):Int={
            val r=x._2.compare(y._2)
            val r2=x._1.compare(y._1)
            if (r==0){
              r2
            }else{
              -r
            }
        }
    }
    val repart_file_2=source.flatMap { line =>
      val origin = line.split("\\|")
      Array(origin(2), origin(6))
    }.map(word => (word, 1)).reduceByKey(_ + _)
      .sortBy(x => x)(mysortBy, ClassTag.apply[Tuple2[String, Int]](classOf[Tuple2[String, Int]]))
      .repartition(1)
      .saveAsTextFile("/home/an/add_count_1")
4,算子的学习
	file=sc.textFile("path")
	4.1 file.count() 得到rdd的行数
	    file.filter(line=>line.contains("Apache")).count() 对rdd进行过滤操作，每一行包含Apache的过滤出来，然后进行统计操作
	4.2 



5,spark-submit 提交

    spark scala 代码进行打包的方法
    更改pom.xml 文件中的plugin 中的mainClass 改为要执行的main的类名称，点击maven project 中的lifeCycle 中的clean 和package 然后点击run maven build进行打包即可

    spark 官网案例
    url http://spark.apache.org/docs/2.3.1/submitting-applications.html
    local 
	spark-submit --class org.apache.Main \
	--master local[3]
	jarpath
	param1 param2

6,概念理解
	driver program，cluster manager，work,executors,tasks,sparkcontext,sparksession
7,RDD 学习
   resilient distributed datasets
   spark program flow whit an rdd includes:
	1,creation of an RDD from a data source.
  2,A set of transformations, for example, filter , map , join , and so on.
	3,Persisting the RDD to avoid re-execution.
	4,Calling actions on the RDD to start performing parallel operations across the cluster.
    创建RDD：
	  sc.parallelize(1 to 20) 不经常在生产环境下使用，因为要求这个数据集在单个节点上可用
	  action：count()
	  transformation： map,flatMap,
  5,不是所有的转换操作都是100%lazy. sortbykey需要评估rdd来确定数据的范围, 因此它涉及既是转变又是行动
8,编写spark程序
  设置master 高可用的情况下  spark://nn1:7077,nn2:7077
  spark-shell --master spark://nn1:7077,nn2:7077































