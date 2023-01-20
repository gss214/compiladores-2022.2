#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdlib.h>
#include <string.h>

struct symrec {
    char* name; // name of symbol
    struct symrec* next; // link field
};

typedef struct symrec symrec;

// Initialization of the list to empty
static symrec* sym_table = (symrec *) 0;
symrec* putsym(char* sym_name);
symrec* getsym(char* sym_name);

// Put an identifier into the table
inline symrec* putsym(char* sym_name) {
    symrec* ptr = (symrec *) malloc (sizeof(symrec));
    ptr->name = (char *) malloc(strlen(sym_name) + 1);
    strcpy(ptr->name, sym_name);
    ptr->next = (struct symrec *) sym_table;
    sym_table = ptr;
    return ptr;
}

// Returns a pointer to the symbol table entry corresponding to an identifier
inline symrec* getsym(char* sym_name) {
    for (symrec* ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *) ptr->next)
        if (strcmp(ptr->name, sym_name) == 0) return ptr;
    return 0;
}

#endif // SYMBOL_TABLE_H
