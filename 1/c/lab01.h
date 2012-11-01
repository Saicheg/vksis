#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <pthread.h>
#include <termios.h>
#include <sys/ipc.h>
#include <sys/shm.h>


#define BAUDRATE B9600
#define SHM_SIZE 1024
// #define SHARED_EXISTS 42
key_t key = 1024;

using namespace std;

void usage(char* cmd);
void* reader_thread(void* pointer);
void configure_com(int fd);
// void write_name(char* id);
// int read_name(char* name);
