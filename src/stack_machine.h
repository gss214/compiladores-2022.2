#ifndef STACK_MACHINE_H
#define STACK_MACHINE_H

#include <string.h>
#include <stdio.h>

// Representacao interna das operacoes
enum code_ops { HALT, STORE, JMP_FALSE, GOTO,
                DATA, LD_INT, LD_VAR,
                READ_INT, WRITE_INT,
                LT, EQ, GT, ADD, SUB, MULT, DIV, PWR };

// Representacao externa das operacoes
static char* op_name[] = { "halt", "store", "jmp_false", "goto",
                           "data", "ld_int", "ld_var",
                           "in_int", "out_int",
                           "lt", "eq", "gt", "add", "sub", "mult", "div", "pwr" };

struct instruction {
    enum code_ops op;
    int arg;
};

static struct instruction code[999]; // Armazena programa (read only)
static int stack[999];               // Armazena dados

static struct instruction ir;        // Registrador de instrucao (Instruction Register)
static int pc = 0;                   // Registrador de endereço de programa (Program Counter)
static int ar = 0;                   // Registrador de ativacao (Activation Register)
static int top = 0;                  // Registrador de topo da pilha (Top Register)

static inline void fetch_execute_cycle() { 
    
    FILE* object_code = fopen("out/object.ogui", "w+");

    do {
        // Carrega
        ir = code[pc++];
        fprintf(object_code, "%2d: %-12s%d\n", pc - 1, op_name[ir.op], ir.arg);

        // Executa
        switch (ir.op) {
            case HALT:      printf("Halt\n"); 
                            break;

            case READ_INT:  printf("Input: ");
                            scanf("%d", &stack[ar+ir.arg]); 
                            break;

            case WRITE_INT: printf("Output: %d\n", stack[top--]); 
                            break;

            case STORE:     stack[ir.arg] = stack[top--]; 
                            break;

            case JMP_FALSE: if (stack[top--] == 0)
                                pc = ir.arg;
                            break;

            case GOTO:      pc = ir.arg; 
                            break;

            case DATA:      top = top + ir.arg;
                            break;

            case LD_INT:    stack[++top] = ir.arg;  
                            break;

            case LD_VAR:    stack[++top] = stack[ar+ir.arg];
                            break;

            case LT:        if (stack[top-1] < stack[top])
                                stack[--top] = 1;
                            else
                                stack[--top] = 0;
                            break;

            case EQ:        if (stack[top-1] == stack[top])
                                stack[--top] = 1;
                            else
                                stack[--top] = 0;
                            break;

            case GT:        if (stack[top-1] > stack[top])
                                stack[--top] = 1;
                            else
                                stack[--top] = 0;
                            top--;
                            break;

            case ADD:       stack[top-1] = stack[top-1] + stack[top];
                            top--;
                            break;

            case SUB:       stack[top-1] = stack[top-1] - stack[top];
                            top--;
                            break;

            case MULT:      stack[top-1] = stack[top-1] * stack[top];
                            top--;
                            break;

            case DIV:       stack[top-1] = stack[top-1] / stack[top];
                            top--;
                            break;

            case PWR:       stack[top-1] = stack[top-1] * stack[top];
                            top--;
                            break;

            default:        printf("Internal Error: Memory Dump\n");
                            break;
        }
    } while (ir.op != HALT);

    fclose(object_code);
}

#endif // STACK_MACHINE_H
