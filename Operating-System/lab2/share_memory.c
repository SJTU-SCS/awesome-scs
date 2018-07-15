#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#define SHMKEY 10000 /* 共享内存关键字 */
#define SIZE 2048 /* 共享内存长度 */
#define SEMKEY1 15001 /* 信号灯组 1关键字 */
#define SEMKEY2 15002 /* 信号灯组 2关键字 */

static void semcall(int sid,int op) // 修改信号灯的值
{
	struct sembuf sb;
	sb.sem_num = 0;
	sb.sem_op = op;
	sb.sem_flg = 0;
	if(semop(sid,&sb,1) == -1) {
		printf("semop error.");
	}
}

int creatsem(key)
	key_t key;
	{
		int sid;
		union semun{ /* 如 sem.h中已定义，则省略 */
			int val;
			struct semid_ds *buf;
			ushort *array;
		} arg;
		if((sid=semget(key,1,0666|IPC_CREAT))==-1){ // 关键词为1的信号灯组，权限0666
			printf("semget error."); //出错处理 
		}
		arg.val=1;
		if(semctl(sid,0,SETVAL,arg)==-1){ // 如果失败将会返回-1
			printf("semctl error."); //出错处理 
		}
		return(sid);
	}

void P(sid) // 信号灯的op值减1
	int sid;
	{
		semcall(sid,-1);
	}

void V(sid) // 信号灯的op值增1
	int sid;
	{
		semcall(sid,1);
	}

int main()
{
	char *segaddr; // 共享内映射的地址指针
	int segid,sid1,sid2;
	if((segid=shmget(SHMKEY,SIZE, IPC_CREAT|0666))==-1) { // 共享内存申请失败
		printf("shmget error.");
	}
	segaddr=shmat(segid,0,0); /* 将共享内存映射到进程数据空间 */
	sid1=creatsem(SEMKEY1); /* 创建两个信号灯，初值为1 */
	sid2=creatsem(SEMKEY2);
	P(sid2); /* 置信号灯 2值为 0，表示缓冲区空 */
	if(!fork()){
		while(1) { /* 子进程，接收和输出 */
			FILE *FileOpen1=fopen("output4.txt","w");
			if(FileOpen1){
				P(sid1); 				  // 改变sid1的信号值
				fputs(segaddr,FileOpen1); // 共享内存中的值存入output2.txt
				fputc('\n', FileOpen1);   // 增加一个换行符
				fclose(FileOpen1);
				V(sid2);				  // 改变sid2的信号值
			}
			else{
				exit(1);
			}
		}
	}
	else{
		while(1){ /* 父进程，输入和存储 */
			FILE *FileOpen2=fopen("input.txt","r");
			if(FileOpen2){
				P(sid2);				    // 改变sid2的信号值
				while((*segaddr=fgetc(FileOpen2))!=EOF){
        			printf("%s",*segaddr);
    			}
				V(sid1);				    // 改变sid1的信号值
				fclose(FileOpen2);
			}
			else{
				exit(1);
			}
		}
	}
}