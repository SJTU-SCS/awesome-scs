#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

// declare a struct to store the memory piece
struct map_unit {
    unsigned m_size;
    char *m_addr;
    struct map_unit *prior;
    struct map_unit *next;
};

struct map_unit *coremap; // current memory piece
struct map_unit *head; // head pointer
struct map_unit *tail; // tail pointer

// allocate memory
char *lmalloc(unsigned size){
    struct map_unit *current_p = coremap;
    do{
        // if current piece is ok
        if (current_p->m_size>=size){
            current_p->m_size -= size;
            current_p->m_addr += size;
            // if current piece is used up
            if (current_p->m_size==0){
                current_p->prior->next = current_p->next;
                current_p->next->prior = current_p->prior;
            }
            return current_p->m_addr - size;
        }else{
            // point to the next piece
            current_p = current_p->next;
        }
    }while(current_p!=coremap);
    return NULL;
}

// set the memory free
bool lfree(unsigned size,char *addr){
    struct map_unit *current_p = head;
    do{
        // situation a
        if ((current_p->m_addr+current_p->m_size==addr)
            &&(current_p->next->m_addr>addr+size)){
            current_p->m_size += size;
            return true;
        }
        // situation b
        else if ((current_p->m_addr+current_p->m_size==addr)
            &&(current_p->next->m_addr==addr+size)){
            current_p->m_size += size + current_p->next->m_size;
            current_p->next = current_p->next->next;
            free(current_p->next->prior); // free memory
            current_p->next->prior = current_p;
            return true;
        }
        // situation c
        else if ((current_p->m_addr+current_p->m_size<addr)
            &&(current_p->next->m_addr==addr+size)){
            current_p->next->m_addr -= size;
            current_p->next->m_size += size;
            return true;
        }
        // situation d
        else if ((current_p->m_addr+current_p->m_size<addr)
            &&(current_p->next->m_addr>addr+size)){
            struct map_unit *new_map=(struct map_unit*)malloc(sizeof(struct map_unit));
            new_map->m_addr = addr;
            new_map->m_size = size;
            new_map->next = current_p->next;
            new_map->prior = current_p;
            current_p->next = new_map;
            new_map->next->prior = new_map;
            return true;
        }
        else{
            current_p = current_p->next;
        }
    }while(current_p!=head);
    return false;
}

// traverse the memory piece list
void traverse(){
    struct map_unit *current_p=head;
    printf("############# current free memory ############\n");
    printf("##### address ################# size #########\n");
    int t = 1;
    do{
        printf("### %10u ################ %6u #######\n",current_p->m_addr-head->m_addr,current_p->m_size);
        current_p = current_p->next;
        t++;
    }while(current_p!=head&& t<10);
    printf("##############################################\n\n");
}

int main(){
    // apply for three pointer
    coremap = (struct map_unit*)malloc(sizeof(struct map_unit));
    head = (struct map_unit*)malloc(sizeof(struct map_unit));
    tail = (struct map_unit*)malloc(sizeof(struct map_unit));
    // apply for 10000 memory size
    coremap->m_addr = (char *)malloc(10000);
    head->m_addr = coremap->m_addr;
    tail->m_addr = coremap->m_addr + 9999;
    // initialize the size
    coremap->m_size = 10000;
    head->m_size = 0;
    tail->m_size = 0;
    // connection
    coremap->next = tail;
    coremap->prior = head;
    head->next = coremap;
    head->prior = tail;
    tail->next = head;
    tail->prior = coremap;

    char c; // store the command
    unsigned size;
    printf("############## memory allocation is initialed ###############\n");
    printf("input 'm size' to allocate a memory piece at the size of 'size'. \n");
    printf("input 'f size addr' to free a memory piece from 'addr' at the size of 'size'. \n");
    printf("input 'q' to quit this memory allocating the system \n\n");

    do{
        // filter out the '\t' '\n' ' '
        while (!(c=getchar()));
        // allocate memory
        if (c=='m'){
            char *allo_addr;
            scanf("%u",&size);
            printf("################ allocate memory #############\n");
            allo_addr = lmalloc(size);
            if (allo_addr){
                printf("allocate memory at address %u, size=%u\n",allo_addr,size);
                traverse();
            }else{
                printf("memory allocation fail!\n");
                traverse();
            }
        }
        // free memory
        else if (c=='f'){
            char *addr;
            scanf("%u %u",&size, &addr);
            printf("################## free memory ###############\n");
            if (lfree(size, (char *)(head->m_addr)+(int)(addr))){
                printf("free memory at address %u, size=%u\n",addr,size);
                traverse();
            }else{
                printf("free memory fail!\n");
                traverse();
            }
        }
    }while(c!='q');
    free(coremap);
    free(head);
    free(tail);
    printf("################### good bye! #################\n\n");
    return 0;
}

