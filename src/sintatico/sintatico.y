%{
#include <stdio.h> 

void yyerror(char*);
int yylex(void);
%}
%token inteiro real id comentario comentario_em_bloco output exit_cmd
%%

line        : programa exit_cmd ';' {printf ("Programa sintaticamente correto!\n");}
            | output exp ';'        {printf("%d\n", $2);}
            | line output exp ';'   {printf("%d\n", $3);}
            ;

programa    : '{' cmd_list '}'		{;}
            ;

cmd_list    : cmd                   {;}
            | cmd ';' cmd_list      {printf("é um comando\n");}

cmd         : id '=' exp            {printf("é uma comando\n");}
            ;

exp         : inteiro               {printf("INTEIRO ");}
            | id                    {printf("ID ");}
		    | exp exp '+'       	{printf("é uma exp\n");}
            ;

%%
int main (void) {
	return yyparse ();
}

void yyerror (char *s){
	printf ("Problema com a analise sintatica!\n");
}
