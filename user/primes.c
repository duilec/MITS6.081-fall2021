#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"

#define LIMIT 35
#define INT_SIZE 4
#define READ 0
#define WRITE 1
#define NUMBERLIMIT 34  /* real limit of number is (35 - 2 + 1) = 34 */
#define UNPRIME 0       /* 0 is not prime */

void print_and_filter_primes(int* fd);

int main(){
	int first_fd[2];
	int numbers[NUMBERLIMIT];
	
    /* build first_fd*/
	pipe(first_fd);
	
	/* first child */
	if (fork() == 0)
        print_and_filter_primes(first_fd);
	
	
	/* first parent */
	else{
        close(first_fd[READ]);
  		/* feed numbers */
    	for (int i = 2; i <= LIMIT; ++i)
       		numbers[i - 2] = i;	     
        write(first_fd[WRITE], &numbers, (NUMBERLIMIT) * INT_SIZE);
        close(first_fd[WRITE]);

        wait(0);
        exit(0);
	}
	return 0;
}

void print_and_filter_primes(int* fd){
    close(fd[WRITE]);

    int prime = UNPRIME;
    int numbers[LIMIT];
    int next_fd[2];
    int temp;
    int count = 0;

    read(fd[READ], (int *)&prime, INT_SIZE);

    if (prime == UNPRIME)
        exit(0);
        
    /* the first number => 2 => is_prime */
    /* each time only print a prime */
    printf("prime %d\n", prime);

    /* filter numbers as next input */
    /* the next numbers may prime or un_prime */
    /* but the last number is prime */
    while (read(fd[READ], &temp, INT_SIZE) > 0)
        if (temp % prime != 0) 
            numbers[count++] = temp;
  
    /* aviod fd overflow*/
    close(fd[READ]);
	
    /* build next_fd*/
	pipe(next_fd);	
	
    /* next child */
	if (fork() == 0){
        print_and_filter_primes(fd);
	}

    /* next parent */
    else{
        close(next_fd[READ]);
        write(next_fd[WRITE], &numbers, count * INT_SIZE);
        close(next_fd[WRITE]);

        wait(0);
        exit(0);
    }
}