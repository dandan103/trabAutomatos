%{
#include <stdio.h>

#define YY_TYPE char *
#include "bash.tab.h"

%}

%%

[ \t]	            	    ;
\n		                    {return T_NEWLINE;}
"ls"	            	    {return T_LIST;}
"ps"	            	    {return T_PS;}
"cd"	            	    {return T_CD;}
"kill"                      {return T_KILL;}
"touch"                     {return T_TOUCH;}
"ifconfig"                  {return T_IFCONFIG;}
"exit"                      {return T_QUIT;}
"quit"                      {return T_QUIT;}
"start"                     {return T_START;}
"mkdir"                     {return T_MKDIR;}
"rmdir"                     {return T_RMDIR;}
([a-zA-Z]":")*"/"*[a-zA-Z]+[0-9]*(\.+[a-z]+)* {yylval.a = yytext; return T_PARAM;}
[+*-/]  	                {return *yytext;}
[0-9]+  	                {yylval.num = atoi(yytext); return T_NUM;}

%%
