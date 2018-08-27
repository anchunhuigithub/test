spark 学习笔记
1, spark version 1.6.2   scala version 2.10.5
    exakple:
        wordcount 
2,scala 语法总结
    1,scala 变量
    2,if while 
    3,class
    4,abstract class
        类的一个或者多个方法没有完整的定义
        声明抽象方法不需要使用abstract 关键字, 只需要不懈方法体
        字类重写父类抽象方法时不需要加override关键字
        父类可以生命抽象字段(没有初始值字段)
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





