#ifndef PARSER_H
#define PARSER_H

#include "symbol_table.h"
#include "utils.h"
#include <stdio.h>

// Arquivo de entrada
extern FILE* yyin;

static unsigned int errors = 0;

// Relatorio de erros
static inline void report_errors() {
    if (!errors)
        printf(GRN "Nenhum erro encontrado\n" RESET);

    else
    {
        printf(RED "%d erro(s) encontrado(s)\n" RESET, errors);
        exit(1);
    }
}

// If e while
typedef struct lbs {
    int for_goto;
    int for_jmp_false;
    struct lbs* next;
} lbs;

// Inicializa a lista de labels
static lbs* lbs_list = NULL;

// Aloca espaço para as labels
static struct lbs* create_label() {
    lbs* ptr = (struct lbs *) malloc(sizeof(struct lbs));
    ptr->next = lbs_list;
    lbs_list = ptr;
    
    return ptr;
}

// Esvazia a lista de labels
static inline void clear_label_list(lbs* ptr) {
    if (ptr == NULL) return;

    clear_label_list(ptr->next);
    free(ptr);
} 

// Insere um identificador na tabela de simbolos
static inline void install(char* sym_name) { 
    symrec* s;
    s = getsym(sym_name);
    if (s == 0) s = putsym(sym_name);
    else {
        errors++;
        printf(YLW "Erro: variavel '%s' ja esta definida\n" RESET, sym_name);
        report_errors();
    }
}

// Checagem de contexto
static inline void context_check(enum code_ops operation, char* sym_name) {
    symrec* identifier = getsym(sym_name);
    if (identifier == 0) {
        errors++;
        printf(YLW "Erro: variavel '%s' nao foi declarada\n" RESET, sym_name);
        report_errors();
    }
    else gen_code(operation, (union stack_t) {.intval = identifier->offset});
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
