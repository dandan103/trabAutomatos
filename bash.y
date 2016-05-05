%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
//extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	char *a;
}

%token T_PARAM
%token T_NEWLINE T_QUIT
%left T_LIST T_CD

%start bashing

%%

bashing: 
	   | bashing line
;

line: T_NEWLINE
    | T_LIST T_NEWLINE { system("ls"); } 
    | T_CD T_PARAM T_NEWLINE { char* buffer = (char *) calloc(1, sizeof(char)); snprintf(buffer, sizeof(buffer), "cd %s", &yylval.a); system(buffer); } 
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

//expression: T_LIST				{ system("ls"); }
//;

%%

int main() {
	yyin = stdin;

	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
