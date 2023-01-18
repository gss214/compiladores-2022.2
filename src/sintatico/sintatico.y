%{
#include <stdio.h>
#include <stdlib.h>

extern FILE* yyin; // Arquivo de entrada

void yyerror(char*);
int yylex(void);
%}

%start program

%token ASSGNOP
%token DO
%token ELSE
%token END
%token FLOAT
%token IDENTIFIER
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

program:        LET declarations IN commands END                {printf("\e[0;32m" ":)\n" "\e[0m");}  
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

command:        SKIP                                            {printf("PULANDO\n");}
                | READ IDENTIFIER                               {printf("LENDO\n");}
                | WRITE exp                                     {printf("PRINTANDO\n");}
                | IDENTIFIER ASSGNOP exp                        {printf("ATRIBUICAO\n");}
                | IF exp THEN commands ELSE commands END        {printf("CONDICAO\n");}
                | IF exp THEN commands END                      {printf("CONDICAO\n");}
                | WHILE exp DO commands END                     {printf("REPETINDO\n");}
                ;

exp:            NUMBER
                | IDENTIFIER
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
	printf("\e[0;31m" "Problema com a analise sintatica!\n");
    printf("Erro: %s\n" "\e[0m", s);
}
