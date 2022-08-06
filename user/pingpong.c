/* Half-duplex Communication */
#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"

int main(int argc, char* argv[]){
	
	int child_pfd[2];
	int parent_pfd[2];
	char buf[4]; /* "ping"or"pong" have 4 char */
	
	pipe(child_pfd);
	pipe(parent_pfd);
	
	/* child */
	if(fork() == 0){
		int child_pid = getpid();
		
		/* close write of parent and read of child */
		close(parent_pfd[1]);
		close(child_pfd[0]);
		
		/*2: received "ping" then child print */
		read(parent_pfd[0], buf, sizeof(buf));
		printf("%d: received %s\n", child_pid, buf);
		
		/*3: write 4 bytes to parent */
		write(child_pfd[1], "pong", sizeof(buf));
		
		exit(0);
	}
	
	/* parent */
	else{
		int parent_pid = getpid();
		
		/* close read of parent and write of child */
		close(parent_pfd[0]);
		close(child_pfd[1]);
		
		/*1: sent 4 bytes to child */
		write(parent_pfd[1], "ping", sizeof(buf));
		
		/*4: received "pong" then parent print */
		read(child_pfd[0], buf, sizeof(buf));
		printf("%d: received %s\n", parent_pid, buf);
		
		wait(0);
		exit(0);
	}
}