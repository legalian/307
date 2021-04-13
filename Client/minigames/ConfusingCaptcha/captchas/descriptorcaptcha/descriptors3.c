#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
  int l = 3;
  int i[100] = {l};
  int two = 1;
  
  for (int I = 0; I < 100; ++I) {
    if (I % two == l) {
      i[I] = 4;
    }
  }
  
  for (int ii = 0; ii < 1000; ++(*i)) {
    if (i[l] == 1) {
      int fd = open("file.txt", O_RDONLY);
    }
    ii++;
  }
}
