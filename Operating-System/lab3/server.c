#include <stdio.h>
#include <stdlib.h>
#include "msgcom.h"
int main()
{
    struct msgtype buf;   // create a message buffer
    int qid;
    if((qid=msgget(MSGKEY,IPC_CREAT|0666))==-1)    // get the message ID
        return(-1);
    while(msgrcv(qid,&buf,1000,5679,MSG_NOERROR)){ // receive message
        FILE *FileOpen=fopen("output4.txt","a");    // open the receive file
        if(FileOpen){
            printf("Server has received some data from the Client:\n");
            printf("#################################################\n");
            printf("%s",buf.msg);                  // print the message
            printf("#################################################\n\n");
            fputs(buf.msg,FileOpen);               // put the message to the file
            fclose(FileOpen);
        }
        else{ // open file failure
            printf("Open file failed.\n");
            exit(1);
        }
    }
}