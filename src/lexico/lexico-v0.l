%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

/* auxiliares */
digito              [0-9]
sinal               [-+]

/* identificadores */
comentario          (\/\/).*\n
comentario_em_bloco [/][*]([^*]|([*]+[^*/]))*[*]+[/]\n
exit_cmd            "exit"
id                  [a-zA-Z_][a-zA-Z0-9_]*
inteiro             {digito}+
real                {digito}+[.]{digito}+
outro               .|\n
output              "output"

%%
{comentario} 		        {return comentario;}
{comentario_em_bloco} 		{return comentario_em_bloco;}
{exit_cmd}                  {return exit_cmd;}
{id}        				{return id;}
{inteiro}			        {return inteiro;}
{real}		        		{return real;}
{outro}	        			{return yytext[0];}
{output}                    {return output;}
%%

int yywrap() {
	return 1;
}
