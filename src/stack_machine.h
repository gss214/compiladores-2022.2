#ifndef STACK_MACHINE_H
#define STACK_MACHINE_H

#include <math.h>
#include <stdio.h>
#include <string.h>
#include "utils.h"


// Representacao interna das operacoes
enum code_ops { HALT, STORE, JMP_FALSE, GOTO,
                DATA, LD_INT, LD_FLOAT, LD_VAR,
                READ_INT, READ_FLOAT, WRITE_INT, WRITE_FLOAT,
                LT, EQ, GT, ADD, SUB, MULT, DIV, PWR };

// Representacao externa das operacoes
static char* op_name[] = { "halt", "store", "jmp_false", "goto",
                           "data", "ld_int", "ld_float", "ld_var",
                           "in_int", "in_float", "out_int", "out_float",
                           "lt", "eq", "gt", "add", "sub", "mult", "div", "pwr" };

enum type {
    INTVAL,
    FLOATVAL
};

// Tipos de dado da pilha
static struct stack_t {
    union {
        int intval;
        float floatval;
    };
    enum type type;
} stack_t;

struct instruction {
    enum code_ops op;
    struct stack_t arg;
};

static struct instruction code[999]; // Armazena programa (read only)
static struct stack_t stack[999];     // Armazena dados

static struct instruction ir;        // Registrador de instrucao (Instruction Register)
static int pc = 0;                   // Registrador de endereço de programa (Program Counter)
static int ar = 0;                   // Registrador de ativacao (Activation Register)
static int top = 0;                  // Registrador de topo da pilha (Top Register)

static inline void fetch_execute_cycle() { 
    
    FILE* object_code = fopen("out/object.ogui", "w+");

    do {
        // Carrega
        ir = code[pc++];

        // Escreve com o tipo correto no arquivo
        switch (ir.arg.type) {
            case INTVAL:
                fprintf(object_code, "%2d: %-12s%d\n", pc - 1, op_name[ir.op], ir.arg.intval);
                break;

            case FLOATVAL:
                fprintf(object_code, "%2d: %-12s%f\n", pc - 1, op_name[ir.op], ir.arg.floatval);
                break;

            default:
                fprintf(object_code, "Tipo %d não é reconhecido\n", ir.arg.type);
                break;
        }

        // Executa
        switch (ir.op) {
            case HALT:          printf("Halt\n"); 
                                break;

            case READ_INT:      printf("Input: ");
                                scanf("%d", &stack[ar+ir.arg.intval].intval);
                                break;

            case READ_FLOAT:    printf("Finput: ");
                                scanf("%f", &stack[ar+ir.arg.intval].floatval); 
                                break;

            case WRITE_INT:     printf("Output: %d\n", stack[top--].intval);
                                break;

            case WRITE_FLOAT:   printf("Floatput: %f\n", stack[top--].floatval);
                                break;

            case STORE:         stack[ir.arg.intval] = stack[top--]; 
                                break;

            case JMP_FALSE:     if (stack[top--].intval == 0)
                                    pc = ir.arg.intval;
                                break;

            case GOTO:          pc = ir.arg.intval;
                                break;

            case DATA:          top = top + ir.arg.intval;
                                break;

            case LD_INT:        stack[++top] = ir.arg;
                                break;

            case LD_FLOAT:      stack[++top] = ir.arg;
                                break;

            case LD_VAR:        stack[++top] = stack[ar+ir.arg.intval];
                                break;

            case LT:            switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].intval < stack[top].intval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                            case FLOATVAL:
                                                if ((float) stack[top-1].intval < stack[top].floatval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].floatval < (float) stack[top].intval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                            case FLOATVAL:
                                                if (stack[top-1].floatval < stack[top].floatval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                        }
                                    break;
                                }
                                break;

            case EQ:            switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].intval == stack[top].intval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                            case FLOATVAL:
                                                if ((float) stack[top-1].intval == stack[top].floatval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].floatval == (float) stack[top].intval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                            case FLOATVAL:
                                                if (stack[top-1].floatval == stack[top].floatval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                        }
                                    break;
                                }
                                break;

            case GT:            switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].intval > stack[top].intval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                            case FLOATVAL:
                                                if ((float) stack[top-1].intval > stack[top].floatval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].floatval > (float) stack[top].intval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                            case FLOATVAL:
                                                if (stack[top-1].floatval > stack[top].floatval)
                                                    stack[--top].intval = 1;
                                                else
                                                    stack[--top].intval = 0;
                                                break;
                                        }
                                    break;
                                }
                                // top--; // ???????????????????
                                break;

            // TODO: Melhorar tratamento de erro
            case ADD:           switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].intval = stack[top-1].intval + stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = (float)stack[top-1].intval + stack[top].floatval;
                                                stack[top-1].type = FLOATVAL;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].floatval = stack[top-1].floatval + (float)stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = stack[top-1].floatval + stack[top].floatval;
                                                break;
                                        }
                                    break;
                                }
                                top--;
                                break;

            case SUB:           switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].intval = stack[top-1].intval - stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = (float)stack[top-1].intval - stack[top].floatval;
                                                stack[top-1].type = FLOATVAL;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].floatval = stack[top-1].floatval - (float)stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = stack[top-1].floatval - stack[top].floatval;
                                                break;
                                        }
                                    break;
                                }
                                top--;
                                break;

            case MULT:          switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].intval = stack[top-1].intval * stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = (float)stack[top-1].intval * stack[top].floatval;
                                                stack[top-1].type = FLOATVAL;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].floatval = stack[top-1].floatval * (float)stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = stack[top-1].floatval * stack[top].floatval;
                                                break;
                                        }
                                    break;
                                }
                                top--;
                                break;

            case DIV:           switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top].intval == 0){
                                                    printf(RED "Divisão por 0\n" RESET);
                                                    exit(1);
                                                }
                                                stack[top-1].intval = stack[top-1].intval / stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                if (stack[top].floatval == 0.0){
                                                    printf(RED "Divisão por 0\n" RESET);
                                                    exit(1);
                                                }
                                                stack[top-1].floatval = (float)stack[top-1].intval / stack[top].floatval;
                                                stack[top-1].type = FLOATVAL;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                if (stack[top-1].intval == 0){
                                                    printf(RED "Divisão por 0\n" RESET);
                                                    exit(1);
                                                }
                                                stack[top-1].floatval = stack[top-1].floatval / (float)stack[top].intval;
                                                break;
                                            case FLOATVAL:
                                                if (stack[top-1].floatval == 0){
                                                    printf(RED "Divisão por 0\n" RESET);
                                                    exit(1);
                                                }
                                                stack[top-1].floatval = stack[top-1].floatval / stack[top].floatval;
                                                break;
                                        }
                                    break;
                                }
                                top--;
                                break;

            case PWR:          switch (stack[top-1].type) {
                                    case INTVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].intval = pow(stack[top-1].intval, stack[top].intval);
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = pow((float)stack[top-1].intval, stack[top].floatval);
                                                stack[top-1].type = FLOATVAL;
                                                break;
                                        }
                                        break;
                                    case FLOATVAL:
                                        switch (stack[top].type) {
                                            case INTVAL:
                                                stack[top-1].floatval = pow(stack[top-1].floatval, (float)stack[top].intval);
                                                break;
                                            case FLOATVAL:
                                                stack[top-1].floatval = pow(stack[top-1].floatval, stack[top].floatval);
                                                break;
                                        }
                                    break;
                                }
                                top--;
                                break;

            default:            printf(RED "Operação %d inválida\n" RESET, ir.op);
                                exit(1);
                                break;
        }
    } while (ir.op != HALT);

    fclose(object_code);
}

#endif // STACK_MACHINE_H
