%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
// #include "symbol-table.h"
#define YYDEBUG 1

struct symrec {
    char* name; // name of symbol
    struct symrec* next; // link field
};

typedef struct symrec symrec;

// Initialization of the list to empty
symrec* sym_table = (symrec *) 0;
symrec* putsym(char* sym_name);
symrec* getsym(char* sym_name);
unsigned int errors = 0;

// Put an identifier into the table
symrec* putsym(char* sym_name) {
    symrec* ptr = (symrec *) malloc (sizeof(symrec));
    ptr->name = (char *) malloc(strlen(sym_name) + 1);
    strcpy(ptr->name, sym_name);
    ptr->next = (struct symrec *) sym_table;
    sym_table = ptr;
    return ptr;
}

// Returns a pointer to the symbol table entry corresponding to an identifier
symrec* getsym(char* sym_name) {
    for (symrec* ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *) ptr->next)
        if (strcmp(ptr->name, sym_name) == 0) return ptr;
    return 0;
}

// installation of an indentifier in the symbol table
void install(char* sym_name) { 
    symrec* s;
    s = getsym(sym_name);
    if (s == 0) s = putsym(sym_name);
    else {
        errors++;
        printf("%s ja esta definido\n", sym_name);
    }
}

// performing context checking
void context_check(char* sym_name) {
    if (getsym(sym_name) == 0)
        printf("%s nao foi declarado\n", sym_name);
}

extern FILE* yyin; // Arquivo de entrada

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

program:        LET declarations IN commands END                {printf("\e[0;32m" ":)\n" "\e[0m");}  
                ;

id_seq:         /* empty */
                | id_seq IDENTIFIER ','                         {printf("S2: %s\n", $2); install($2);}
                ;

declarations:   /* empty */ 
                | declarations INTEGER id_seq IDENTIFIER '.'    {printf("S2: %s\n", $4); install($4);}
                | declarations FLOAT id_seq IDENTIFIER '.'      {printf("S2: %s\n", $4); install($4);}
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
