#include<errno.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/msg.h>
#define MSGKEY 5678
struct msgtype{
    long mtype;      // message type definition
    char msg[1000];  // message block
};
