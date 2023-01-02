%{
#include <stdio.h>
#include <stdlib.h>
%}

/* auxiliares */
digito              [0-9]
sinal               [-+]

/* identificadores */
inteiro             {sinal}?{digito}+\n
real                {sinal}?{digito}+[.]{digito}*\n
id                  [a-zA-Z_][a-zA-Z0-9_]*\n
comentario          (\/\/).*\n
comentario-em-bloco [/][*]([^*]|([*]+[^*/]))*[*]+[/]\n
outro               .*\n

%%
{inteiro}			        {printf("NUMERO INTEIRO\n");}
{real}		        		{printf("NUMERO REAL\n");}
{id}        				{printf("IDENTIFICADOR\n");}
{comentario} 		        {printf("COMENTARIO\n");}
{comentario-em-bloco} 		{printf("COMENTARIO EM BLOCO\n");}
{outro}	        			{printf("NAO IDENTIFICADO\n");}
%%

int yywrap ();

int main() {
	printf("Informe um token e tecle <enter>:\n");
	yylex(); /* scanner gerado por Flex */
}

int yywrap() {
	return 1;
}
