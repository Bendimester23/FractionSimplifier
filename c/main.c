#include <stdio.h>
#include <stdlib.h>

long gcd(long a, long b)
{
    if(a == 0) return b;
    return gcd(b%a, a);
}

char* a;
char* b;
char* string;

int main() {
    a = malloc(24);
    b = malloc(24);
    printf("Hello, User!\n");
    printf("Enter numerator!\n");
    if (fgets(a, 24, stdin) == NULL) {
        return -1;
    }

    printf("Enter denominator!\n");
    if (fgets(b, 24, stdin) == NULL) {
        return -1;
    }

    long aa = strtol(a, &string, 10);
    long bb = strtol(b, &string, 10);

    long g = gcd(aa, bb);

    printf("Result: %ld / %ld\n", aa/g, bb/g);

    return 0;
}
