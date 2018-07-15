#include<sys/types.h>
#include<signal.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/wait.h>
#include<unistd.h>
int main ( )
{
	int status;  // status
	pid_t pid;   // process pid
	void sigFunc(); // declaration of signal processing function
	signal(SIGUSR1,sigFunc);   // SIGSUR1 trigger the func  	
	if (pid=fork()) {// the father process	  
		printf("111111\n");
		kill(pid, SIGUSR1); // send signal SIGUSR1  
		printf("333333333\n");
		wait(& status);     // wait for the return status from the son
		printf("Status=%d, Father process finished.\n",status);
	} else {// the son process
		sleep(1);  
		printf("222222222222");
		exit(2);				
	}
}
void sigFunc() // signal processing function
{
    printf (":::It is signal processing function.\n");
}