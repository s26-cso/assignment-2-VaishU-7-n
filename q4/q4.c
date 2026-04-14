#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

typedef int (*fptr)(int, int);

int main() {
    char op[6];
    int a, b;

    while (scanf("%5s %d %d", op, &a, &b) == 3) {

        char lib[20];
        strcpy(lib, "./lib");
        strcat(lib, op);
        strcat(lib, ".so");

        void *handle = dlopen(lib, RTLD_LAZY);
        if (!handle) continue;

        fptr func = (fptr)dlsym(handle, op);
        if (!func) {
            dlclose(handle);
            continue;
        }

        printf("%d\n", func(a, b));

        dlclose(handle);
    }

    return 0;
}