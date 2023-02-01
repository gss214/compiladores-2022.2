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
                IN                                              {gen_code(DATA, (union stack_t) {.intval = sym_table->offset});}
                    commands
                END                                             {gen_code(HALT, (union stack_t) {.intval =  0}); 
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
                | WRITE exp                                     {gen_code(WRITE_INT, (union stack_t) {.intval = 0});}
                | WRITE_FT exp                                  {gen_code(WRITE_FLOAT, (union stack_t) {.floatval = 0});}
                | IDENTIFIER ASSGNOP exp                        {context_check(STORE, $1);}
                | IF exp                                        {$1 = (struct lbs *) create_label(); $1->for_jmp_false = reserve_loc();}
                    THEN commands                               {$1->for_goto = reserve_loc();}
                  ELSE                                          {back_patch($1->for_jmp_false, JMP_FALSE, (union stack_t) {.intval = gen_label()});}
                        commands
                  END                                           {back_patch($1->for_goto, GOTO, (union stack_t) {.intval = gen_label()});}
                /* | IF exp THEN commands END                      {;} /* @TODO: Ver como esse aqui funciona */
                | WHILE                                         {$1 = (struct lbs *) create_label(); $1->for_goto = gen_label();}
                    exp                                         {$1->for_jmp_false = reserve_loc();}
                  DO
                    commands
                  END                                           {gen_code(GOTO, (union stack_t) {.intval = $1->for_goto}); 
                                                                 back_patch($1->for_jmp_false, JMP_FALSE, (union stack_t) {.intval = gen_label()});}
                ;

exp:            NUMBER_INTEGER                                  {gen_code(LD_INT, (union stack_t) {.intval = $1});}
                | NUMBER_FLOAT                                  {gen_code(LD_FLOAT, (union stack_t) {.floatval = $1});}
                | IDENTIFIER                                    {context_check(LD_VAR, $1);}
                | exp exp '<'                                   {gen_code(LT, (union stack_t) {.intval = 0});}
                | exp exp '='                                   {gen_code(EQ, (union stack_t) {.intval = 0});}
                | exp exp '>'                                   {gen_code(GT, (union stack_t) {.intval = 0});}
                | exp exp '+'                                   {gen_code(ADD, (union stack_t) {.intval = 0});}
                | exp exp '-'                                   {gen_code(SUB, (union stack_t) {.intval = 0});}
                | exp exp '*'                                   {gen_code(MULT, (union stack_t) {.intval = 0});}
                | exp exp '/'                                   {gen_code(DIV, (union stack_t) {.intval = 0});}
                | exp exp '^'                                   {gen_code(PWR, (union stack_t) {.intval = 0});}
                | '(' exp ')'
                ;

%%

void yyerror(char *s) {
    printf(RED "Problema com a analise sintatica!\n");
    printf("Erro: %s\n" RESET, s);
}
