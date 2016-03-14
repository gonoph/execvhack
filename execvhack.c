#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define EXECV 1
#define EXECVP 2
#define EXECVE 3
#define EXECVPE 4

int (*orig_execvp)(const char *__path, char *const __argv[]);
int (*orig_execv)(const char *__path, char *const __argv[]);
int (*orig_execve)(const char *__path, char *const __argv[], char *const __envp[]);
int (*orig_execvpe)(const char *__file, char *const __argv[], char *const __envp[]);

int wrapper (const int __type, const char *__path, char *const __argv[], char *const __envp[]) {
	char *argv = __argv[0];
	int i = 0;
	while (argv != NULL) {
		fprintf(stderr,"%s: argv[%d]: [[%s]]\n", __path, i++, argv);
		argv = __argv[i];
	}
	switch (__type) {
		case EXECV:  return orig_execv(__path, __argv);
		case EXECVP: return orig_execvp(__path, __argv);
		case EXECVE: return orig_execve(__path, __argv, __envp);
		case EXECVPE: return orig_execvpe(__path, __argv, __envp);
		default: fprintf(stderr, "execvhack.so: invalid given function type (%d); error in source code.", __type);
			exit(1);
	}
}

int execvpe(const char *__file, char *const __argv[], char *const __envp[]) {
	return wrapper(EXECVPE, __file, __argv, __envp);
}

int execve (const char *__path, char *const __argv[], char *const __envp[]) {
	return wrapper(EXECVE, __path, __argv, __envp);
}

int execv (const char *__path, char *const __argv[]) {
	return wrapper(EXECV, __path, __argv, NULL);
}
int execvp (const char *__path, char *const __argv[]) {
	return wrapper(EXECVP, __path, __argv, NULL);
}

void __attribute__ ((constructor)) my_init(void) {
	printf("Loading hack.\n");
	orig_execvpe = dlsym(RTLD_NEXT, "execvpe");
	orig_execvp = dlsym(RTLD_NEXT, "execvp");
	orig_execve = dlsym(RTLD_NEXT, "execve");
	orig_execv = dlsym(RTLD_NEXT, "execv");
}

