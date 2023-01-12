%{
#include <stdio.h>
#include "sintatico.h"
%}

/* auxiliares */
DIGIT             			[0-9]
SIGN						[+-]

/* identificadores */
COMMENT_BLOCK 				[/][*]([^*]|([*]+[^*/]))*[*]+[/]
COMMENT_LINE       			(\/\/).*
ID               			[a-z][a-z0-9]*
NUMBER_FLOAT               	{SIGN}?{DIGIT}+[.]{DIGIT}*
NUMBER_INTEGER             	{SIGN}?{DIGIT}+
SPACE						[ \t\n]+

%%
do							{return DO;}
end			    			{return END;}
in		    				{return IN;}
integer						{return INTEGER;}
float						{return FLOAT;}
let			    			{return LET;}
read			    		{return READ;}
write						{return WRITE;}
while						{return WHILE;}

{COMMENT_LINE}				{printf("Comentario em linha\n");}
{COMMENT_BLOCK}				{printf("Comentario em bloco\n");}
{ID}						{return IDENTIFIER;}
{NUMBER_FLOAT}				{return NUMBER;}
{NUMBER_INTEGER}			{return NUMBER;}
{SPACE}						{;}
.							{return(yytext[0]);}
%%

int yywrap() {
	return 1;
}
