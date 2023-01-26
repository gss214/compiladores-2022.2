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

%start program

%union { // SEMANTIC RECORD
    char* id; // For returning identifiers
} 

%token <id> ASSGNOP
%token DO
%token ELSE
%token END
%token FLOAT
%token <id> IDENTIFIER
%token IF
%token IN 
%token INTEGER 
%token LET 
%token NUMBER
%token READ 
%token SKIP
%token THEN
%token WHILE
%token WRITE

%left '-' '+'
%left '*' '/'
%right '^'

%%

program:        LET declarations IN commands END                {printf(GRN ":)\n" RESET);}  
                ;

id_seq:         /* empty */
                | id_seq IDENTIFIER ','                         {printf("S2: %s\n", $2); install($2);}
                ;

declarations:   /* empty */ 
                | declarations INTEGER id_seq IDENTIFIER ';'    {printf("S4: %s\n", $4); install($4);}
                | declarations FLOAT id_seq IDENTIFIER ';'      {printf("S4: %s\n", $4); install($4);}
                ;

commands:       /* empty */
                | commands command ';'                               
                ;

command:        SKIP                                            {printf("PULANDO\n");}
                | READ IDENTIFIER                               {printf("LENDO\n"); context_check($2);}
                | WRITE exp                                     {printf("PRINTANDO\n");}
                | IDENTIFIER ASSGNOP exp                        {printf("ATRIBUINDO\n"); context_check($2);}
                | IF exp THEN commands ELSE commands END        {printf("CONDICAO\n");}
                | IF exp THEN commands END                      {printf("CONDICAO\n");}
                | WHILE exp DO commands END                     {printf("REPETINDO\n");}
                ;

exp:            NUMBER
                | IDENTIFIER                                    {context_check($1);}
                | exp exp '<'
                | exp exp '='
                | exp exp '>'
                | exp exp '+'
                | exp exp '-'
                | exp exp '*'
                | exp exp '/'
                | exp exp '^'
                | '(' exp ')'
                ;

%%

void yyerror(char *s) {
	printf("\e[0;31m" "Problema com a analise sintatica!\n");
    printf("Erro: %s\n" "\e[0m", s);
}
