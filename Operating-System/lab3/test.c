#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main()
{
    FILE *fr; // 输入文件的标识字
    char ch;
    char buf[1024];
    clock_t begin_time, end_time;

    //########## fgets & fputs ###########
    FILE *fp1;
    if((fr=fopen("input.txt","r"))==NULL)
    {
        printf("error\n");
        exit(-1);
    }
    if((fp1=fopen("output1.txt","w"))==NULL)
    {
        printf("error\n");
        exit(-1);
    }
    printf("using fgets & fputs:\n");
    printf("############################\n");
    begin_time = clock();
    while(fgets(buf,1024,fr)){
        printf("%s",buf);
        fputs(buf,fp1);
    }
    end_time = clock();
    printf("############################\n");
    printf("timespan: %f seconds.\n\n", (double)(end_time-begin_time)/1000000);
    fclose(fr);
    fclose(fp1);

    //########## fscanf & fprintf ###########
    FILE *fp2;
    if((fr=fopen("input.txt","r"))==NULL)
    {
        printf("error\n");
        exit(-1);
    }
    if((fp2=fopen("output2.txt","w"))==NULL)
    {
        printf("error\n");
        exit(-1);
    }
    printf("using fscanf & fprintf:\n");
    printf("############################\n");
    begin_time = clock();
    while(fscanf(fr,"%[^\n]",buf)>0){
        printf("%s\n",buf);
        fprintf(fp2,"%s",buf);
        fgetc(fr);
        fprintf(fp2,"%s","\n");
    }
    end_time = clock();
    printf("############################\n");
    printf("timespan: %f seconds.\n\n", (double)(end_time-begin_time)/1000000);
    fclose(fr);
    fclose(fp2);

    //########## fgetc & fputs ###########
    FILE *fp3;
    if((fr=fopen("input.txt","r"))==NULL)
    {
        printf("error\n");
        exit(-1);
    }
    if((fp3=fopen("output3.txt","w"))==NULL)
    {
        printf("error\n");
        exit(-1);
    }
    printf("using fgetc & fputc:\n");
    printf("############################\n");
    begin_time = clock();
    while((ch=fgetc(fr))!=EOF){
        printf("%c",ch);
        fputc(ch,fp3);
    }
    end_time = clock();
    printf("############################\n");
    printf("timespan: %f seconds.\n\n", (double)(end_time-begin_time)/1000000);
    fclose(fr);
    fclose(fp3);
    return 0;
}
