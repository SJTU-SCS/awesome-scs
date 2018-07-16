findit()
{   
	if [ $# -eq 2 ]   			# 参数完全
	then 
	    for i in $*			# 循环该目录下的文件
	    do                        
	        if [ -d $i ]			# 如果文件是目录文件
	        then                
	            echo $i                              	# 打印目录的名称
	            grep $2 -s -n $i/*.c $i/*.h            # grep函数进行字符串匹配
	            (cd $i                       		# 调用子进程递归进行操作
	            for j in *; do
	                findit $j $2 
	            done)
	        fi
	    done
	elif [ $# -eq 1 ]   			# 如果只带一个参数
	then
		findit . $2			# 补全成两个参数的形式
	else
	then
		echo "please use the format: 'findit dir string'"
	fi	
}
findit $1 $2