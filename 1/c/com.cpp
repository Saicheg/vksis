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


#define BUFFER_SIZE 128
#define BAUDRATE    B9600
#define SHM_SIZE 1024
#define SHARED_EXISTS 42
key_t key = 1024;
using namespace std;

void* reader_thread(void* pointer) {
  int* fd = (int*)pointer;
  char inputbyte;
  while (read(*fd, &inputbyte, 1) == 1) {
    cout << inputbyte;
    cout.flush();
  }
  return 0;
}

// void* writer_thread(void* pointer) {
//     char c;
//     while (true) {
//         cin >> c;
//         write(*(int*)pointer, &c, 1);
//     }
//     return 0;
// }

void configure_serial_port(int pointer) {
  /* serial port parameters */
  struct termios newtio;
  memset(&newtio, 0, sizeof(newtio));
  struct termios oldtio;
  tcgetattr(pointer, &oldtio);

  newtio = oldtio;
  newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
  newtio.c_iflag = 0;
  newtio.c_oflag = 0;
  newtio.c_lflag = 0;
  newtio.c_cc[VMIN] = 1;
  newtio.c_cc[VTIME] = 0;
  tcflush(pointer, TCIFLUSH);

  cfsetispeed(&newtio, BAUDRATE);
  cfsetospeed(&newtio, BAUDRATE);
  tcsetattr(pointer, TCSANOW, &newtio);
}

void write_id(char id) {
  int* point = (int*)calloc(2, sizeof(int));
  int shmid=shmget(key, SHM_SIZE, IPC_CREAT | S_IRUSR | S_IWUSR);
  if ((point = (int*)shmat(shmid, 0, 0)) == (int *) -1) {
    cerr << "write shmat error" << endl;
    exit(1);
  }
  point[0] = SHARED_EXISTS;
  point[1] = id;
  shmdt(point);
}

char read_id() {
  int *point;
  int shmid = shmget(key, SHM_SIZE, S_IRUSR | S_IWUSR);
  // Check if availible to get shared memory
  if ((point = (int*)shmat(shmid, 0, 0)) == (int *) -1) {
    return -1;
  }
  cout << "readed id " << *point << " " << *(point+1) << endl;
  // Check if value exists
  if(point[0] == SHARED_EXISTS) {
    char id = point[1];
    shmdt(point);
    return id;
  }
  return -1;
}

int main(int argc, char** argv) {
  int fd, name_id;
  char c;
  char name[] = "/dev/pts/ ";
  name_id = read_id();

  if(name_id < 0) {
    cout << "creating new pts" << endl;
    fd = open("/dev/ptmx", O_RDWR | O_NOCTTY);
    if (fd == -1) {
      cerr << "error opening file" << endl;
      return -1;
    }
    char* name_id = ptsname(fd);
    write_id((int)name_id[9]); // Write id to shared memory
  } else {
    name[9] = (char)name_id;
    cout << "reading pts with name:" << name << endl;
    fd = open(name, O_RDWR);
    if (fd == -1) {
      cerr << "error opening file" << endl;
      return -1;
    }
  }

  grantpt(fd);
  unlockpt(fd);
  configure_serial_port(fd); // Configure serial port

  // pthread_t thread_reader, thread_writer;
  // pthread_create(&thread_reader, 0, reader_thread, (void*) &fd);
  // pthread_create(&thread_writer, 0, reader_thread, (void*) &fd);cout << "reading: " << ptsname(fd) << endl;
  cout << "ptsname: " << ptsname(fd) << endl;
  cout << "fd: " << fd << endl;
  while (true) {
    cin >> c;
    write(fd, &c, 1);
  }


  return 0;
}
