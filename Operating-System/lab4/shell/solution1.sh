findit()
{   
	if [ $# -eq 2 ]   			# ������ȫ
	then 
	    for i in $*			# ѭ����Ŀ¼�µ��ļ�
	    do                        
	        if [ -d $i ]			# ����ļ���Ŀ¼�ļ�
	        then                
	            echo $i                              	# ��ӡĿ¼������
	            grep $2 -s -n $i/*.c $i/*.h            # grep���������ַ���ƥ��
	            (cd $i                       		# �����ӽ��̵ݹ���в���
	            for j in *; do
	                findit $j $2 
	            done)
	        fi
	    done
	elif [ $# -eq 1 ]   			# ���ֻ��һ������
	then
		findit . $2			# ��ȫ��������������ʽ
	else
	then
		echo "please use the format: 'findit dir string'"
	fi	
}
findit $1 $2