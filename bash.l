%{
#include <stdio.h>

//#define YY_DECL int yylex()
#define YY_TYPE char *

#include "bash.tab.h"

%}

%%

[ \t]		; // ignore all whitespace
"ls"		{return T_LIST;}
[a-z]+	 	{yylval.a = yytext; return T_PARAM;}
\n		{return T_NEWLINE;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}

%%
