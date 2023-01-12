#include <stdio.h>
#include <stdlib.h>

void parse_file(char file[]);

int main(int argc, char **argv) {

    if (argc < 2) {
        printf("Nenhum arquivo fornecido\n");
        exit(1);
    }
    
    parse_file(argv[1]);

    return 0;
}