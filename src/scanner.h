#ifndef SCANNER_H
#define SCANNER_H

#include <stdlib.h>
#include <string.h>

typedef struct str {
    char* string;
    struct str* next;
} str;

// Inicializa a lista de strings
static str* str_list = NULL;

// Insere na lista de strings
static inline char* insert_yyval(char* text) {
    char* string = strdup(text);

    str* ptr = (struct str *) malloc(sizeof(struct str));
    ptr->string = string;
    ptr->next = str_list;
    str_list = ptr;
    
    return string;
}

// Esvazia a lista de strings
static inline void clear_yyval_list(str* ptr) {
    if (ptr == NULL) return;

    clear_yyval_list(ptr->next);
    free(ptr);
}

#endif // SCANNER_H
