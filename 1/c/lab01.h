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

#define BAUDRATE B9600

using namespace std;

void usage(char* cmd);
void* reader_thread(void* pointer);
