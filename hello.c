//#include <stdio.h>

int main(int argn, char** args)
{
	printf("num=%d\n", argn);
	for(int i=0;i<argn;i++)
		printf("args[%d]=%s\n",i,args[i]);
	printf("hello\n");
	return 0;
}
