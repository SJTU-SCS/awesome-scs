#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>  
#include <errno.h> 
#include <time.h>  
#define READ_BUFF 1024 

int main(int argc,char *argv[]){ 
    clock_t begin_time, end_time; 
    if(argc < 3)  // 判断参数是否齐全
    {  
        printf("input param error\n");  
        return -1;  
    }  
  
    FILE * fileSourceHandler = NULL;  
    FILE * fileDestHandler = NULL;  
    fileSourceHandler = fopen(argv[1],"r");  
    fileDestHandler = fopen(argv[2],"w");  
    if(fileSourceHandler == NULL || fileDestHandler == NULL)  // 文件打开是否正常
    {  
        printf("open %s or %s failed:%s\n",argv[1],argv[2],strerror(errno));  
        return -2;  
    }  
  
    char buf[READ_BUFF];  
    int nread;  
    begin_time = clock();  // 记录文件复制前的时间
    while( nread = fread(buf,1,1,fileSourceHandler))  // 逐个字符读文件
    {  
        fwrite(buf,1,nread,fileDestHandler);  // 逐个字符写文件
    }  
    printf("copy %s success\n", argv[1]); // 写完成
    end_time = clock(); // 记录文件复制后的文件
    fclose(fileDestHandler);  
    fclose(fileSourceHandler);  
    // 打印使用了多少时间
    printf("timespan: %f seconds.\n", (double)(end_time-begin_time)/1000000);
    return 0;  
}