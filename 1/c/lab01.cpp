#include "lab01.h"

int main(int argc, char** argv) {
  if (argc < 2) usage(argv[0]);
  int fd = 0;
  string name = "/dev/pts/ ";
  name[9] = argv[1][0];
  cout << "Port name: " << name << endl;

  fd = open(name.c_str(), O_RDWR | O_NOCTTY);
  if (fd == -1) {
    cerr << "error opening file" << std::endl;
    return -1;
  }

  grantpt(fd);
  unlockpt(fd);
  configure_com(fd);

  /* start reader thread */
  pthread_t thread;
  pthread_create(&thread, 0, reader_thread, (void*) &fd);

  /* read from stdin and send it to the serial port */
  string c;
  while (true) {
    cin >> c;
    write(fd, c.c_str(), c.size());
    write(fd, "\n", 1);
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
  cerr << "usage: " << cmd << " <Port number>" << endl;
  exit(1);
}

