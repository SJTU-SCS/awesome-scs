#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
int main(){
        FILE* fr=fopen("input.txt", "r");
        FILE* fw=fopen("output5.txt","w");
        clock_t begin_time, end_time;
        int fd[2];
        char buf[1024];
        pipe(fd);
        if(fork())
        {       //父进程
                close(fd[0]);   //关闭管道读端 
                printf("##### unnamed pipe #######\n");
                printf("############################\n");
                begin_time =clock();
                while(fgets(buf,1024,fr)){
                        write(fd[1],buf,1024);  // 在管道写
                        printf("%s",buf);
                }
                end_time = clock();
                printf("############################\n");
                printf("timespan: %f seconds.\n\n", (double)(end_time-begin_time)/1000000);
                close(fd[1]);   //关闭管道写端
                fclose(fr);
        }
        else{   //子进程
                close(fd[1]);   //关闭管道写端
                while(read(fd[0],buf,1024)){    // 从管道读
                        fputs(buf,fw);
                }
                close(fd[0]);   //关闭管道读端 
                fclose(fw);
        }
}