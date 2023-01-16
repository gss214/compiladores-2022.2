#include <dirent.h>
#include <stdio.h>
#include <string.h>

// Cores
#define RED   "\e[0;31m"
#define GRN   "\e[0;32m"
#define YLW   "\e[0;33m"
#define BLU   "\e[0;34m"
#define CYN   "\e[0;36m"
#define WHT   "\e[0;37m"
#define RESET "\e[0m"

void parse_file(char file[]);

void run_all_tests() {

    DIR* d;
    struct dirent* dir;
    d = opendir("test");

    // Abre o diretório de testes e testa todos os arquivos
    if (d) {
        while ((dir = readdir(d)) != NULL) {
            if (dir->d_type == DT_REG) {
                char file[200] = "test/";
                strcat(file, dir->d_name);
                printf(BLU "\n\nParsing file: %s\n" RESET, file);
                parse_file(file);
            }
        }

        closedir(d);
    }
}

int main() {

    run_all_tests();    

    return 0;
}
