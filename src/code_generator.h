#ifndef CODE_GENERATOR_H
#define CODE_GENERATOR_H

#include "stack_machine.h"
#include <stdio.h>

/*
*   Geracao de codigo e formada por tres partes:
*   - Segmento de dados;
*   - Segmento de codigo;
*   - Pilha de expressoes (stack machine);
*/

// Segmento de dados
static int data_offset = 0;
static inline int data_location() { return data_offset++; }

// Segmento de codigo
static int code_offset = 0;
static inline int reserve_loc() { return code_offset++; }
static inline int gen_label() { return code_offset; }

static inline void gen_code(enum code_ops operation, union stack_t arg) {
    code[code_offset].op = operation;
    code[code_offset++].arg = arg;
}

static inline void back_patch(int addr, enum code_ops operation, union stack_t arg) {
    code[addr].op = operation;
    code[addr].arg = arg;
}

#endif // CODE_GENERATOR_H
