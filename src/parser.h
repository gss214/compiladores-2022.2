#ifndef PARSER_H
#define PARSER_H

#include "symbol_table.h"
#include <stdio.h>

// Arquivo de entrada
extern FILE* yyin;

static unsigned int errors = 0;

// If e while
typedef struct lbs {
    int for_goto;
    int for_jmp_false;
    struct lbs* next;
} lbs;

// Inicializa a lista de labels
static lbs* lbs_list = NULL;

// Aloca espaço para as labels
static struct lbs* newlblrec() {
    lbs* ptr = (struct lbs *) malloc(sizeof(struct lbs));
    ptr->next = lbs_list;
    lbs_list = ptr;
    
    return ptr;
}

// Esvazia a lista de labels
static inline void clear_label(lbs* ptr) {
    if (ptr == NULL) return;

    clear_label(ptr->next);
    free(ptr);
} 

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
static inline void context_check(enum code_ops operation, char* sym_name) {
    symrec* identifier = getsym(sym_name);
    if (identifier == 0) {
        errors++;
        printf("%s nao foi declarado\n", sym_name);
    }
    else gen_code(operation, identifier->offset);
}

int yyparse();

// Abre e faz parse no arquivo fornecido
static inline void parse_file(char file[]) {
 
    yyin = fopen(file, "r");
 
    if (yyin == NULL) {
        printf("Não foi possível abrir o arquivo\n");
        exit(1);
    }
    
    yyparse();

    fclose(yyin);
}

#endif // PARSER_H
