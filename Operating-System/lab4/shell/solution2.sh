space=""  		# 保存需要输出的“-”
category()		
{   
    for i in *; do                        # 循环遍历当前目录所有文件
        if [ -d $i ]; then               # 如果当前文件是个目录
            echo $space$i            # 打印该目录的名称                          
            (cd $i	               # 调用子进程递归操作
             space="----$space"  # 进入一层前置“-”加四个                    
             category)
        else
        	echo -e $space$i    # 返回文件名
        fi
    done
}
category