#include <stdio.h>
#include <stdlib.h>
#include "msgcom.h"
#include <time.h>
int main()
{
   struct msgtype buf; // create a buffer
   clock_t begin_time, end_time;
   int qid;
   qid=msgget(MSGKEY,IPC_CREAT|0666);        // get the queue of message
   buf.mtype=5679; 
   FILE *FileOpen=fopen("input.txt","r");    // open the message file
   begin_time = clock();
   printf("Client has sent the following Message to the Server.\n");
   printf("############################\n");
   if(FileOpen){
      while(fgets(buf.msg, 1000, FileOpen)){ // read message by line
         printf("%s",buf.msg);
         msgsnd(qid,&buf,sizeof(buf.msg),0); // send the message
         }
   }
   else{
      printf("Open file failed.\n");
      exit(1);
   }
   end_time = clock();
   printf("############################\n");
   printf("timespan: %f seconds.\n", (double)(end_time-begin_time)/1000000);
   fclose(FileOpen);
}