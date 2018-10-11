                                算法学习
1,  排序算法学习
      1,  冒泡排序
              思想: 
                  冒泡, 可以类比一下水中的泡泡, 从下到上泡泡逐渐变大
                  类比排序的话就是 相邻数据比较大小, 打的放到后面, 小的放到前面
              实现:

                public static int[] poolSort(int[] para){
                   
                   for(int i=0;i<para.length-1;i++){
                      
                      for(int j=i;j<para.length-1;j++){
                        
                        if(para[j]>para[j+1]){
                            int tamp=para[j];
                            para[j]=para[j+1];
                            para[j+1]=tamp;
                        }
                      }
                   }
                   return para;
                }
