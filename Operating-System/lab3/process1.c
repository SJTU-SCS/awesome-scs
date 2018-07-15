#include <fcntl.h>
#include <sys/stat.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#define BUFSIZE 1024
int main(){
	int fd;
	char buf[BUFSIZE];
	mknod("named_pipe",S_IFIFO|0666,0); // 创建一个有名管道
	fd=open("named_pipe",O_WRONLY); // 打开有名管道，只写模式
	FILE* fp=fopen("input.txt","r"); // 从input.txt读入数据
	while(fgets(buf,sizeof(buf),fp)){
		write(fd,buf,strlen(buf)+1); // 数据写入管道
	}
	close(fd);
	fclose(fp);
}