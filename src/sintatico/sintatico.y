%{
#include <stdio.h>
#include <stdlib.h>

extern FILE* yyin; // Arquivo de entrada

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

program:        LET declarations IN commands END                {printf(":)\n");}  
                ;

id_seq :        /* empty */
                | id_seq IDENTIFIER ','             
                ;

declarations:   /* empty */ 
                | declarations INTEGER id_seq IDENTIFIER '.'    {printf("DECLARANDO INT\n");}
                | declarations FLOAT id_seq IDENTIFIER '.'      {printf("DECLARANDO FLOAT\n");}
                ;

commands:       /* empty */
                | commands command ';'                               
                ;

command:        READ IDENTIFIER                                 {printf("LENDO\n");}
                | WRITE exp                                     {printf("PRINTANDO\n");}
                | WHILE exp DO commands END                     {printf("REPETINDO\n");}
                ;

exp:            NUMBER
                | IDENTIFIER
                ;

%%

/* Abre e faz parse no arquivo fornecido */
void parse_file(char file[]) {
 
    yyin = fopen(file, "r");
 
    if (yyin == NULL) {
        printf("Não foi possível abrir o arquivo\n");
        exit(1);
    }
    
    while (feof(yyin) == 0)
        yyparse();

    fclose(yyin);
}

void yyerror(char *s) {
	printf("Problema com a analise sintatica!\n");
    printf("Erro: %s\n", s);
}
