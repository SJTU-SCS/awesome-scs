#include <unistd.h>  
#include <sys/types.h>  
#include <sys/stat.h>  
#include <stdio.h>  
#include <fcntl.h> 
#include <time.h> 
  
int main(int argc, char *argv[]) {  
    clock_t begin_time, end_time;
    if (argc != 3) {  // 判断参数是否齐全
        printf("input param error\n");  
        return -1;   
    }     
  
    int s_fd = open(argv[1], O_RDONLY);  
    if (s_fd == -1) {  // 打开待复制文件
        printf("open %s error\n", argv[1]);  
        return -1;   
    }     
  
    int d_fd = open(argv[2], O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);  
    if (d_fd == -1) {  // 打开复制到的文件
        printf("open %s error\n", argv[2]);  
        return -1;   
    }     

    begin_time = clock(); // 记录文件复制前的时间
    char ch;
    while (true) {  
        int rdRes = read(s_fd, &ch, 1);  // 逐个字符读文件
        if (rdRes == -1) {  // 读文件出错
            printf("read %s error\n", argv[1]);  
            return -1;   
        } else if (rdRes == 0) {  // 读文件完成
            printf("copy %s success\n", argv[1]);  
            break;  
        } else if (rdRes == 1) {  // 读文件过程中
            int wrRes = write(d_fd, &ch, 1);   
            if (wrRes != 1) {  // 写文件出错
                printf("write %s error\n", argv[2]);  
                return -1;   
            }     
        } else {  
            printf("unknow error\n");  
            return -1;   
        }     
    }     
    end_time = clock(); // 记录文件复制后的文件
    // 打印使用了多少时间
    printf("timespan: %f seconds.\n", (double)(end_time-begin_time)/1000000);
    return 0;  
} 