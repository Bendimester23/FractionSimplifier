#include <stdio.h>
#include <stdlib.h>

long gcd(long a, long b) {
    long max;
    if (a > b) {
        max = b;
    } else {
        max = a;
    }
    long gcb = 1;

    for (int i = 1; i <= max; ++i) {
        if (a % i == 0 && b % i == 0 && i > gcb) {
            gcb = i;
        }
    }
    return gcb;
}

int main() {
    printf("Hello, User!\n");
    char a[32];
    char b[32];
    printf("Enter top number!\n");
    if (fgets(a, 32, stdin) == NULL) {
        return -1;
    }

    printf("Enter bottom number!\n");
    if (fgets(b, 32, stdin) == NULL) {
        return -1;
    }


    char * string;

    long aa = strtol(a, &string, 10);
    long bb = strtol(b, &string, 10);

    long g = gcd(aa, bb);

    printf("Result: %ld / %ld\n", aa/g, bb/g);

    return 0;
}


