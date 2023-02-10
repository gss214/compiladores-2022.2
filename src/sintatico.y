%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include "../src/parser.h"
#include "../src/scanner.h"
#include "../src/symbol_table.h"
#include "../src/utils.h"

#define YYDEBUG 1

void yyerror(char*);
int yylex(void);
extern int yylineno;
%}

%union {            // Acrescentar tipos aqui
    int intval;     // Inteiro
    float floatval; // Float 
    char* id;       // Identificadores
    struct lbs* lbls;
} 

%start program
%token <id> ASSGNOP
%token DO
%token ELSE
%token END
%token FLOAT
%token <id> IDENTIFIER
%token <lbls> IF WHILE
%token IN 
%token INTEGER 
%token LET 
%token <intval> NUMBER_INTEGER
%token <floatval> NUMBER_FLOAT
%token READ 
%token READ_FT
%token SKIP
%token THEN
%token WRITE
%token WRITE_FT

%left '-' '+'
%left '*' '/'
%right '^'

%%

program:        LET 
                    declarations
                IN                                              {gen_code(DATA, (struct stack_t) {.intval = sym_table->offset});}
                    commands
                END                                             {gen_code(HALT, (struct stack_t) {.intval =  0}); 
                                                                 fetch_execute_cycle();
                                                                 clear_table(sym_table);
                                                                 clear_label_list(lbs_list);
                                                                 clear_yyval_list(str_list);
                                                                 report_errors();
                                                                 YYACCEPT;}
                ;

declarations:   /* empty */                                     {install("0");}
                | declarations INTEGER id_seq IDENTIFIER ';'    {install($4);}
                | declarations FLOAT id_seq IDENTIFIER ';'      {install($4);}
                ;

id_seq:         /* empty */
                | id_seq IDENTIFIER ','                         {install($2);}
                ;

commands:       /* empty */
                | commands command ';'                               
                ;

command:        SKIP
                | READ IDENTIFIER                               {context_check(READ_INT, $2);}
                | READ_FT IDENTIFIER                            {context_check(READ_FLOAT, $2);}
                | WRITE exp                                     {gen_code(WRITE_INT, (struct stack_t) {.intval = 0});}
                | WRITE_FT exp                                  {gen_code(WRITE_FLOAT, (struct stack_t) {.floatval = 0});}
                | IDENTIFIER ASSGNOP exp                        {context_check(STORE, $1);}
                | IF exp                                        {$1 = (struct lbs *) create_label(); $1->for_jmp_false = reserve_loc();}
                    THEN commands                               {$1->for_goto = reserve_loc();}
                  ELSE                                          {back_patch($1->for_jmp_false, JMP_FALSE, (struct stack_t) {.intval = gen_label()});}
                    commands
                  END                                           {back_patch($1->for_goto, GOTO, (struct stack_t) {.intval = gen_label()});}
                | WHILE                                         {$1 = (struct lbs *) create_label(); $1->for_goto = gen_label();}
                    exp                                         {$1->for_jmp_false = reserve_loc();}
                  DO
                    commands
                  END                                           {gen_code(GOTO, (struct stack_t) {.intval = $1->for_goto}); 
                                                                 back_patch($1->for_jmp_false, JMP_FALSE, (struct stack_t) {.intval = gen_label()});}
                ;

exp:            NUMBER_INTEGER                                  {gen_code(LD_INT, (struct stack_t) {.intval = $1, .type = INTVAL});}
                | NUMBER_FLOAT                                  {gen_code(LD_FLOAT, (struct stack_t) {.floatval = $1, .type = FLOATVAL});}
                | IDENTIFIER                                    {context_check(LD_VAR, $1);}
                | exp exp '<'                                   {gen_code(LT, (struct stack_t) {.intval = 0});}
                | exp exp '='                                   {gen_code(EQ, (struct stack_t) {.intval = 0});}
                | exp exp '>'                                   {gen_code(GT, (struct stack_t) {.intval = 0});}
                | exp exp '+'                                   {gen_code(ADD, (struct stack_t) {.intval = 0});}
                | exp exp '-'                                   {gen_code(SUB, (struct stack_t) {.intval = 0});}
                | exp exp '*'                                   {gen_code(MULT, (struct stack_t) {.intval = 0});}
                | exp exp '/'                                   {gen_code(DIV, (struct stack_t) {.intval = 0});}
                | exp exp '^'                                   {gen_code(PWR, (struct stack_t) {.intval = 0});}
                | '(' exp ')'
                ;

%%

void yyerror(char *s) {
    printf(RED "Problema com a analise sintatica na linha %d!\n" RESET, yylineno);
}
