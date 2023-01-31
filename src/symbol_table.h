#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdlib.h>
#include <string.h>
#include "code_generator.h"

typedef struct symrec {
    char* name; // nome do simbolo
    int offset; // deslocamento dos dados
    struct symrec* next; // ponteiro para o proximo
} symrec;

// Inicializa a lista vazia
static symrec* sym_table = (symrec *) 0;

// Adiciona um identificador a lista
static inline symrec* putsym(char* sym_name) {
    symrec* ptr = (symrec *) malloc (sizeof(symrec));
    ptr->name = (char *) malloc(strlen(sym_name) + 1);
    strcpy(ptr->name, sym_name);
    ptr->offset = data_location();
    ptr->next = (struct symrec *) sym_table;
    sym_table = ptr;
    return ptr;
}

// Retorna um ponteiro para o simbolo com nome dado
static inline symrec* getsym(char* sym_name) {
    for (symrec* ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *) ptr->next)
        if (strcmp(ptr->name, sym_name) == 0) return ptr;
    return 0;
}

// Esvazia a lista
static inline void clear_table(symrec* ptr) {
    if (ptr == NULL) return;

    clear_table(ptr->next);
    free(ptr->name);
    free(ptr);
}

#endif // SYMBOL_TABLE_H
