
#include <stdio.h>
#include <stdint.h>

long int largest();

int main()
{
long int result_code = largest();
	printf("%s%ld","\nThe largest value in the array is: ", result_code);
	printf("%s","\nMain will return 0 to the operating system. Bye.\n");
	return 0;
}
