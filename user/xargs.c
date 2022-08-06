#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h"

int main(int argc, char **argv) {
    int i, j;
    char *args_parray[MAXARG];
    char all_args_buffer[256];
    char *ptr_buffer = all_args_buffer;
    char *ptr_array =  ptr_buffer;

    for(i = 1, j = 0; i < argc; i++)
        args_parray[j++] = argv[i]; /* when loop break, j == argv - 1 */

    int length;
    int total_length = 0;
    while ((length = read(0, ptr_buffer, MAXARG)) > 0){ /* 0 is pipe of reading */
        total_length += length;
        if(total_length > 256){
            printf("the args is too long!");
            exit(0);
        }

        for(i = 0; i < length; ++i){
            if(ptr_buffer[i] == ' '){
                ptr_buffer[i] = '\0'; /* c-style: the last of string has '\0' */
                args_parray[j++] = ptr_array; /* add new args to args_parray */
                ptr_array = &ptr_buffer[i + 1]; /* ptr_array point to next */
            }
            else if(ptr_buffer[i] == '\n'){
                ptr_buffer[i] = '\0';
                args_parray[j++] = ptr_array;
                args_parray[j] = '\0'; /* as args of exec (c-style: string has '\0') */
                ptr_array = &ptr_buffer[i + 1];
                
                if(fork() == 0){
                    exec(argv[1], args_parray);
                    exit(0);
                }

                j = argc - 1; /* comeback, eg: echo "1\n2" | xargs -n 1 echo line */
                wait(0);
            }
        }
        ptr_buffer += length;
    }
    exit(0);
}
