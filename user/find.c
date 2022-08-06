#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *name);
char* get_path_lastname(char *path);
void compare(char *path_lastname, char *name);

int main(int argc, char *argv[]) {
/*  // Input Error! 
    if (argc < 3){
        printf("Input Error!");
        exit(0);
    }
 */
    find(argv[1], argv[2]);
    exit(0);    
}

void find(char *path, char *name) {
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0) {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }    

    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type){
        case T_FILE:
        	/* empty dir is file(T_FILE)  */
            /* must use recursion in order to push and pop*/
            compare(path, name);
            break;
        case T_DIR:
            if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
                printf("ls: path too long\n");
                break;
            }

            strcpy(buf, path);
            p = buf + strlen(buf);
            *p++ = '/';
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
                if (de.inum == 0 || strcmp(".", de.name) == 0 || strcmp("..", de.name) == 0)
                    continue;
                
                memmove(p, de.name, strlen(de.name)); 
                p[strlen(de.name)] = '\0';
                find(buf, name);
            }
            break;
    }
    close(fd);
}

char* get_path_lastname(char *path) {
    static char buf[DIRSIZ+1];
    char *p;

    /* order: from the last char to first slash('/') */
    for(p = path + strlen(path); p >= path && *p != '/'; p--)
        ;
    
    /* since p-- point to last slash('/') */
    /* p++ point to last char */
    p++;  

    // Return file name to cmp 
    if(strlen(p) >= DIRSIZ)
        return p;
    memmove(buf, p, sizeof(p));
    p[strlen(buf)] = '\0';
    return buf;
}

void compare(char *path, char *name){
    if(strcmp(get_path_lastname(path), name) == 0)
        printf("%s\n", path);
    return;
}