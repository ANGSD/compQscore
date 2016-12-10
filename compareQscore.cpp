#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cassert>
#define MLEN 4096


int main(int argc,char**argv){
  fprintf(stderr,"argc:%d\n",argc);
  for(int i=0;i<argc;i++)
    fprintf(stderr,"\t-> %d) %s\n",i,argv[i]);
  FILE *i1 = fopen(argv[1],"r");
  FILE *i2 = fopen(argv[2],"r");

  char buf1[MLEN];
  char buf2[MLEN];
  size_t cnts[256][256];
  for(int i=0;i<256;i++)
    for(int j=0;j<256;j++)
      cnts[i][j]=0;
  while(fgets(buf1,MLEN,i1)){
    //    fprintf(stderr,"BUF1:%s\n",buf1);
    fgets(buf2,MLEN,i2);

    //validate consistency
    char *saveptr1,*saveptr2;
    char *tok1,*tok2;

    tok1=strtok_r(buf1," \n\r\t",&saveptr1);
    tok2=strtok_r(buf2," \n\r\t",&saveptr2);
    assert(strcmp(tok1,tok2)==0);
    int atCol=1;
    while(atCol<10){
      tok1=strtok_r(NULL," \n\r\t",&saveptr1);
      tok2=strtok_r(NULL," \n\r\t",&saveptr2);
      assert(strcmp(tok1,tok2)==0);
      atCol++;
    }
    tok1=strtok_r(NULL," \n\r\t",&saveptr1);
    tok2=strtok_r(NULL," \n\r\t",&saveptr2);
    assert(strlen(tok1)==strlen(tok2));
    for(unsigned i=0;i<strlen(tok1);i++)
      //      fprintf(stdout,"%d\t%d\t%d\n",tok1[i],tok2[i],tok2[i]-tok1[i]);
      cnts[tok1[i]][tok2[i]]++;
  }


  for(int i=0;i<256;i++){
    for(int j=0;j<256;j++)
      fprintf(stdout,"%lu\t",cnts[i][j]);
    fprintf(stdout,"\n");
  }
  return 0;
}
