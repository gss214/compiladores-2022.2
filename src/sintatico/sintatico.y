%{
#include <stdio.h> 
#include <stdlib.h>

void yyerror(char*);
int yylex(void);
%}

%token inteiro
%token real
%token id
%token comentario
%token comentario_em_bloco
%token exit_cmd
%token print_cmd

%%
line        : programa '\n'                  {printf("Programa sintaticamente correto!\n");}
            | print_cmd exp '\n'             {printf("PRINT NUM\n");}
            | line print_cmd exp '\n'        {printf("PRINT EXP\n");}
            | exit_cmd '\n'                  {exit(0);}
            ;

programa    : '{' cmd_list '}'		{;}
            ;

cmd_list    : cmd                   {;}
            | cmd ';' cmd_list      {;}
            ;

cmd         : id '=' exp            {;}
            ;

exp         : inteiro               {;}
            | id                    {;}
		    | exp exp '+'       	{;}
            ;

%%
int main(void) {
	return yyparse();
}

void yyerror(char *s) {
	printf("Problema com a analise sintatica!\n");
    printf("Erro: %s\n", s);
}
