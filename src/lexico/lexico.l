%{
#include <stdio.h>
#include <string.h>
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
":="						{return ASSGNOP;}
do							{return DO;}
else						{return ELSE;}
end			    			{return END;}
float						{return FLOAT;}
if 							{return IF;}
in		    				{return IN;}
integer						{return INTEGER;}
let			    			{return LET;}
read			    		{return READ;}
skip						{return SKIP;}
then						{return THEN;}
while						{return WHILE;}
write						{return WRITE;}

{COMMENT_LINE}				{;}
{COMMENT_BLOCK}				{;}
{ID}                        {yylval.id = (char *) strdup(yytext); return IDENTIFIER;}
{NUMBER_FLOAT}				{yylval.intval = atoi(yytext); return NUMBER;} /* @TODO: float */
{NUMBER_INTEGER}			{yylval.intval = atoi(yytext); return NUMBER;}
{SPACE}						{;}
.							{return(yytext[0]);}
%%

int yywrap() {
	return 1;
}
