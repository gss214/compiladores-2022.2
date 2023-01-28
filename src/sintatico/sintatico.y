%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include "../src/parser.h"
#include "../src/symbol_table.h"
#include "../src/utils.h"

#define YYDEBUG 1

void yyerror(char*);
int yylex(void);
%}

%union { // SEMANTIC RECORD
    int intval; // Valor inteiro
    char* id; // Identificadores
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
%token <intval> NUMBER
%token READ 
%token SKIP
%token THEN
%token WRITE

%left '-' '+'
%left '*' '/'
%right '^'

%%

program:        LET 
                    declarations
                IN                                              {gen_code(DATA, sym_table->offset);}
                    commands
                END                                             {gen_code(HALT, 0); fetch_execute_cycle(); YYACCEPT;}
                ;

id_seq:         /* empty */
                | id_seq IDENTIFIER ','                         {install($2);}
                ;

declarations:   /* empty */                                     {install("0");}
                | declarations INTEGER id_seq IDENTIFIER ';'    {install($4);}
                | declarations FLOAT id_seq IDENTIFIER ';'      {install($4);}
                ;

commands:       /* empty */
                | commands command ';'                               
                ;

command:        SKIP
                | READ IDENTIFIER                               {context_check(READ_INT, $2);}
                | WRITE exp                                     {gen_code(WRITE_INT, 0);}
                | IDENTIFIER ASSGNOP exp                        {context_check(STORE, $1);}
                | IF exp                                        {$1 = (struct lbs *) newlblrec(); $1->for_jmp_false = reserve_loc();}
                    THEN commands                               {$1->for_goto = reserve_loc();}
                    ELSE                                        {back_patch($1->for_jmp_false, JMP_FALSE, gen_label());}
                        commands
                  END                                           {back_patch($1->for_goto, GOTO, gen_label());}
                /* | IF exp THEN commands END                      {;} /* @TODO: Ver como esse aqui funciona */
                | WHILE                                         {$1 = (struct lbs *) newlblrec(); $1->for_goto = gen_label();}
                    exp                                         {$1->for_jmp_false = reserve_loc();}
                  DO
                    commands
                  END                                           {gen_code(GOTO, $1->for_goto); back_patch($1->for_jmp_false, JMP_FALSE, gen_label());}
                ;

exp:            NUMBER                                          {gen_code(LD_INT, $1);}
                | IDENTIFIER                                    {context_check(LD_VAR, $1);}
                | exp exp '<'                                   {gen_code(LT, 0);}
                | exp exp '='                                   {gen_code(EQ, 0);}
                | exp exp '>'                                   {gen_code(GT, 0);}
                | exp exp '+'                                   {gen_code(ADD, 0);}
                | exp exp '-'                                   {gen_code(SUB, 0);}
                | exp exp '*'                                   {gen_code(MULT, 0);}
                | exp exp '/'                                   {gen_code(DIV, 0);}
                | exp exp '^'                                   {gen_code(PWR, 0);}
                | '(' exp ')'
                ;

%%

void yyerror(char *s) {
    printf("\e[0;31m" "Problema com a analise sintatica!\n");
    printf("Erro: %s\n" "\e[0m", s);
}
