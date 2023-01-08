%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

/* auxiliares */
DIGIT             			[0-9]
ID               			[a-z][a-z0-9]*
SPACE						[ \t\n]+

%%
do							{return DO;}
end			    			{return END;}
in		    				{return IN;}
integer						{return INTEGER;}
let			    			{return LET;}
read			    		{return READ;}
write						{return WRITE;}
while						{return WHILE;}
{ID}						{return IDENTIFIER;}
{DIGIT}+					{return NUMBER;}
{SPACE}						{;}
.							{return(yytext[0]);}
%%

int yywrap() {
	return 1;
}
