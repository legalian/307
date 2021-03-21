#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <string>
#include <cstdlib>

int main(){
	for(int i = 1; i <= 359; i++) {
		char * conimage = new char[300];
		sprintf(conimage, "convert img/updatewheel.png -distort SRT %d %d-image.png", i, i);
		printf("%s\n", conimage);
		std::system(conimage);
		delete[] conimage;
	}
	std::string makepage = "convert -page +0+0 img/updatewheel.png";
	for(int i = 1; i <= 359; i++) {
		char * appended = new char[100];
		int x = ((i % 20)) * 640;
		int y = ((i / 20)) * 640;
		sprintf(appended, " -page +%d+%d %d-image.png", x, y, i);
		makepage += appended;
		delete[] appended;
	}
	makepage += " -mosaic img/final.png";
	printf("%s\n", makepage.c_str());
	
	std::system(makepage.c_str());
	system("rm *.png");
}
