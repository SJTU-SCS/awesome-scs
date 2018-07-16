#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>

#define BUFSIZE 1024
int main(){
	int fd,n;
	clock_t begin_time, end_time;
	char buf[BUFSIZE];
	fd=open("named_pipe",O_RDONLY); // 打开有名管道，只写模式
	FILE* fp=fopen("output6.txt","w"); // 数据流出文件
	printf("####### named pipe #############\n");
    printf("############################\n");
    begin_time = clock();
	while((n=read(fd,buf,sizeof(buf)))>0){	// 从有名管道读入数据
		fputs(buf,fp);	// 输出到文件
		printf("%s",buf);
	}
	end_time = clock();
	printf("############################\n");
	printf("timespan: %f seconds.\n\n", (double)(end_time-begin_time)/1000000);
	close(fd);
	fclose(fp);
}