#include <stdio.h>

void parse_file(char file[]);

int main(int argc, char **argv) {

    if (argc >= 2)
        parse_file(argv[1]);

    else
        printf("Nenhum arquivo de entrada fornecido\n");

    return 0;
}
