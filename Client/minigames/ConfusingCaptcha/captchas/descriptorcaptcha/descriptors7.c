#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
  for (int i = 0; i < 38; ++i) {
    open("/dev/null", O_RDONLY);
  }
}

