space=""  		# ������Ҫ����ġ�-��
category()		
{   
    for i in *; do                        # ѭ��������ǰĿ¼�����ļ�
        if [ -d $i ]; then               # �����ǰ�ļ��Ǹ�Ŀ¼
            echo $space$i            # ��ӡ��Ŀ¼������                          
            (cd $i	               # �����ӽ��̵ݹ����
             space="----$space"  # ����һ��ǰ�á�-�����ĸ�                    
             category)
        else
        	echo -e $space$i    # �����ļ���
        fi
    done
}
category