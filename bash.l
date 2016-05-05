%{
#include <stdio.h>

//#define YY_DECL int yylex()
#define YY_TYPE char *

#include "bash.tab.h"

%}

%%

[ \t]		; // ignore all whitespace
\n		{return T_NEWLINE;}
"ls"		{return T_LIST;}
"ps"		{return T_PS;}
"cd"		{return T_CD;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}
[a-zA-Z]+	 	{yylval.a = yytext; return T_PARAM;}

%%



