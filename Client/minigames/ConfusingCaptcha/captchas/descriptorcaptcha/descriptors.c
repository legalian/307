#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
  int l = 2;
  int I[100] = {l};
  int two = 3;
  
  for (int i = 0; i < 100; ++i) {
    if (i % two == l) {
      I[i] = 1;
    }
  }
  
  for (int i = 0; i < 100; ++i) {
    if (I[i] == 1) {
      int fd = open("file.txt", O_RDONLY);
    }
  }
}
