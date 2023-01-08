%{
#include "y.tab.h"
%}

/* auxiliares */
digito              [0-9]
sinal               [-+]

/* identificadores */
comentario          (\/\/).*\n
comentario_em_bloco [/][*]([^*]|([*]+[^*/]))*[*]+[/]\n
espaco		        [ \t]+
exit_cmd            "exit"
id                  [a-zA-Z_][a-zA-Z0-9_]*
inteiro             {digito}+
real                {digito}+[.]{digito}+
outro               .|\n
print_cmd			"print"

%%
{comentario} 		        {return comentario;}
{comentario_em_bloco} 		{return comentario_em_bloco;}
{espaco}            		{;}
{exit_cmd}                  {return exit_cmd;}
{print_cmd}					{return print_cmd;}
{id}        				{return id;}
{inteiro}			        {return inteiro;}
{real}		        		{return real;}
{outro}	        			{return yytext[0];}
%%

int yywrap() {
	return 1;
}
