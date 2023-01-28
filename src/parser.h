#ifndef PARSER_H
#define PARSER_H

#include "symbol_table.h"
#include <stdio.h>

// Arquivo de entrada
extern FILE* yyin;

static unsigned int errors = 0;

int yyparse();

// Insere um identificador na tabela de simbolos
static inline void install(char* sym_name) { 
    symrec* s;
    s = getsym(sym_name);
    if (s == 0) s = putsym(sym_name);
    else {
        errors++;
        printf("%s ja esta definido\n", sym_name);
    }
}

// Checagem de contexto
static inline void context_check(char* sym_name) {
    if (getsym(sym_name) == 0)
        printf("%s nao foi declarado\n", sym_name);
}

// Abre e faz parse no arquivo fornecido
static inline void parse_file(char file[]) {
 
    yyin = fopen(file, "r");
 
    if (yyin == NULL) {
        printf("Não foi possível abrir o arquivo\n");
        exit(1);
    }
    
    while (feof(yyin) == 0)
        yyparse();

    fclose(yyin);
}

#endif // PARSER_H
