%{
#include <stdio.h>
#include <stdlib.h>
%}

sinal [-|+]
inteiro {sinal}?[0-9]+\n
real {sinal}?[0-9]+[.][0-9]*\n
id [a-z][a-z0-9]*\n
comentario (\/\/).*\n
outro .*\n

%%
{inteiro}			{printf("INTEIRO\n");}
{real}				{printf("NUMERO REAL\n");}
{id}				{printf("IDENTIFICADOR\n");}
{comentario} 		{printf("COMENTARIO\n");}
{outro}				{printf("NAO IDENTIFICADO\n");}
%%

int yywrap ();

int main() {
	printf("Informe um token e tecle <enter>:\n");
	yylex(); /* scanner gerado por Flex */
}

int yywrap() {
	return 1;
}