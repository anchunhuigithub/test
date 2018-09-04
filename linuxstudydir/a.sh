#!/bin/bash
echo `date`
date_now=`date +"%Y-%m-%d %H:%M:%S"`
echo $date_now
date_tomorrow=`date -d "2 days ago" +"%Y-%m-%d %H:%M:%S"`
echo 两天前的时间为:"$date_tomorrow"
# 得到两天后的时间
data_two_days_after=`date -d "-2 days ago"+"%Y-%m-%d"`

