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
    int num;
}

%token T_PARAM T_SINAL
%token T_NEWLINE T_QUIT
%token T_LIST T_CD T_PS

%token <num> T_NUM
%type <num> expression

%start bashing

%%

bashing: 
	   | bashing line {printf(">> ");}
;

line: T_NEWLINE
    | T_LIST T_NEWLINE { system("ls"); } 
    | T_CD T_PARAM T_NEWLINE { char buffer[60]; sprintf(buffer, "cd %s", yylval.a); system(buffer); } 
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
    | expression T_NEWLINE { printf("%d\n", $1); }
;

expression: T_NUM { $$ = $1; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { $$ = $1 / $3; }
;

%%

int main() {
	yyin = stdin;
    printf(">> ");
	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
