#include "lab01.h"

int main(int argc, char** argv) {
  if (argc < 2) usage(argv[0]);

  int fd = 0;
  string mode = argv[1];

  if (mode == "slave") {
    char* name = (char*)calloc(1024, sizeof(char));
    read_name(name);
    fd = open(name, O_RDWR);
    if (fd == -1) {
      cerr << "error opening file" << std::endl;
      return -1;
    }

  }else if (mode=="master") {

    // fd = open("/dev/ptmx", O_RDWR | O_NOCTTY);
    fd = open(argv[2], O_RDWR | O_NOCTTY);
    if (fd == -1) {
      cerr << "error opening file" << std::endl;
      return -1;
    }
    grantpt(fd);
    unlockpt(fd);
    char* pts_name = ptsname(fd);
    cerr << "ptsname: " << pts_name << endl;
    write_name(pts_name);
  } else {
    usage(argv[1]);
  }

  configure_com(fd);

  /* start reader thread */
  pthread_t thread;
  pthread_create(&thread, 0, reader_thread, (void*) &fd);

  /* read from stdin and send it to the serial port */
  char c;
  while (true) {
    cin >> c;
    write(fd, &c, 1);
  }

  close(fd);
  return 0;
}

void configure_com(int fd) {
  /* serial port parameters */
  struct termios newtio;
  memset(&newtio, 0, sizeof(newtio));
  struct termios oldtio;
  tcgetattr(fd, &oldtio);

  newtio = oldtio;
  newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
  newtio.c_iflag = 0;
  newtio.c_oflag = 0;
  newtio.c_lflag = 0;
  newtio.c_cc[VMIN] = 1;
  newtio.c_cc[VTIME] = 0;
  tcflush(fd, TCIFLUSH);

  cfsetispeed(&newtio, BAUDRATE);
  cfsetospeed(&newtio, BAUDRATE);
  tcsetattr(fd, TCSANOW, &newtio);
}

void* reader_thread(void* pointer) {
  int* fd = (int*)pointer;
  char inputbyte;
  while (read(*fd, &inputbyte, 1) == 1) {
    cout << inputbyte;
    cout.flush();
  }

  return 0;
}

void usage(char* cmd) {
  cerr << "usage: " << cmd << "slave|master" << endl;
  exit(1);
}

void write_name(char* id) {
  int len = strlen(id);

  char* point = (char*)calloc(2, sizeof(int));
  int shmid = shmget(key, SHM_SIZE, IPC_CREAT | S_IRUSR | S_IWUSR);

  if ((point = (char*)shmat(shmid, 0, 0)) == (char*) -1) {
    cerr << "write shmat error" << endl;
    exit(1);
  }
  strcpy(point, id);
  shmdt(point);
}

int read_name(char* name) {
  char* point;
  int shmid = shmget(key, SHM_SIZE, S_IRUSR | S_IWUSR);
  // Check if availible to get shared memory
  if ((point = (char*)shmat(shmid, 0, 0)) == (char*) -1) {
    return -1;
  }
  strcpy(name, point);
  return 1;
}


