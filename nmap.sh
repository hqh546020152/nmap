#! /bin/bash
#

look_port="3306 6379" 			#该变量用于记录要统计对应开放端口的数量

date_go=`date +%s`			#脚本开始时间
echo "" > test.txt			#清空原有记录数据，多次运行时要保存文档
echo "-------------------------------------------" >> test.txt			#分隔符
cat ip_file |while read LINE;do							#逐行读取
        for I in $LINE;do
		echo -e "\033[1;31m$I：\033[0m" >> test.txt
        	nmap -sV $I 2> /dev/null | grep "tcp" >> test.txt		#扫描
		A=$?
   		[ $A -ne 0 ] && echo "没有该主机或无法连接" >> test.txt
		echo "-------------------------------------------" >> test.txt	#分割符
        done
done

date_end=`date +%s`			#脚本结束时间
let date_d=$date_end-$date_go
mm=0
hh=0
let mm=$date_d/60
let hh=$date_d%60
echo "探测耗时时间：$mm分钟$hh秒" >> test.txt	#统计运行时间

for port in $look_port ;do			
	BT=`cat test.txt | grep "^$port\>" | grep "\<open\>" | wc -l` 	#查看指定端口是否有开放，并统计数量
	echo "$port端口共开放 $BT个" >> test.txt	
done

let sui=$date_go%100				#以脚本开始时间搓取一个随机数
filename=`date +%Y%m%d`_$sui.txt		#定义文本名称
cp test.txt $filename 				#文本进行保存
