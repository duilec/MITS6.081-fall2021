#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"

int
main(int agrc, char* agrv[]){
  /* argc is the number of commands*/
  /* argv[] store the context of parameters */
  if(agrc == 1){
    printf("Please enter parameter of int");
  }else {
    int time = atoi(agrv[1]);
    sleep(time);
  }
    exit(0);
}
