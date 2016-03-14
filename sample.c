#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(const int argc, const char *argv[], const char *envp[]) {
	int i;
	char *path, **args;
	if (argc < 2) {
		fprintf(stderr, "Usage: %s <path to command> (<arguments>)\n", argv[0]);
		exit(1);
	}
	path = strdup(argv[1]);
	args = (char**)calloc(argc, sizeof(char*));
	for (i = 1 ; i < argc ; i++) {
		args[i-1] = strdup(argv[i]);
	}
	args[i]=NULL;
	execvp(path, args);
	perror("Unable to execvp()");
	exit(-1);
}
