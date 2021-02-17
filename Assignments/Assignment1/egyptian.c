#include <stdio.h>
#include <stdint.h>

long int start();

int main()
{long int result_code = -999;
	printf("%s","Welcome to your friendly circle circumference calculator\n");
	printf("%s","The main program will now call the circle function\n");
	result_code = start();
	printf("%s%ld\n","The main recieved this integer: ",result_code);
	printf("%s","Have a nice day. Main will now return 0 to the operating system.\n");
	return 0;
}
