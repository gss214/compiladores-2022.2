#include <stdio.h>
#include <stdlib.h>
#include "test.h"

void parse_file(char file[]);

int main(int argc, char **argv) {

    if (argc >= 2)
        parse_file(argv[1]);

    else
        run_all_tests();

    return 0;
}