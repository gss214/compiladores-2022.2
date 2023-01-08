%{
#include <stdio.h>

void yyerror(char*);
int yylex(void);
%}

%start program

%token DO
%token END 
%token FLOAT
%token IN 
%token IDENTIFIER
%token INTEGER 
%token LET 
%token READ 
%token NUMBER
%token WHILE
%token WRITE

%%

program:        LET declarations IN commands END        {printf(":)\n");}  
                ;

id_seq :        /* empty */
                | id_seq IDENTIFIER ','             
                ;

declarations:   /* empty */ 
                | INTEGER id_seq IDENTIFIER '.'         {printf("DECLARANDO\n");}
                ;

commands:       /* empty */
                | commands command ';'                               
                ;

command:        READ IDENTIFIER                         {printf("LENDO\n");}
                | WRITE exp                             {printf("PRINTANDO\n");}
                | WHILE exp DO commands END             {printf("REPETINDO\n");}
                ;

exp:            NUMBER
                | IDENTIFIER
                ;

%%
int main(void) {
	return yyparse();
}

void yyerror(char *s) {
	printf("Problema com a analise sintatica!\n");
    printf("Erro: %s\n", s);
}
