%{

#include <unistd.h>
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

%token T_PARAM T_SINAL T_NEWLINE T_QUIT T_KILL
%token T_LIST T_CD T_PS T_TOUCH T_START T_MKDIR T_RMDIR T_IFCONFIG  

%token <num> T_NUM
%type <num> expression

%start bashing

%%

bashing: 
	   | bashing line { char cwd[60]; getcwd(cwd, sizeof(cwd)); printf("Bashinho:%s >> ", cwd); }
;

line: T_NEWLINE
    | T_LIST T_NEWLINE { system("ls"); } 
    | T_PS T_NEWLINE { system("ps"); }
    | T_CD T_PARAM T_NEWLINE { cd(); } 
    | T_KILL T_NUM T_NEWLINE { char buffer[60]; sprintf(buffer, "kill %d", yylval.num); system(buffer); }
    | T_TOUCH T_PARAM T_NEWLINE { char buffer[60]; sprintf(buffer, "touch %s", yylval.a); system(buffer); printf("Arquivo %s criado", yylval.a); }
    | T_START T_PARAM T_NEWLINE { char buffer[60]; sprintf(buffer, "exec ./%s", yylval.a); system(buffer); }
    | T_MKDIR T_PARAM T_NEWLINE { char buffer[60]; sprintf(buffer, "mkdir %s", yylval.a); system(buffer); }
    | T_RMDIR T_PARAM T_NEWLINE { char buffer[60]; sprintf(buffer, "rmdir %s", yylval.a); system(buffer); }
    | T_IFCONFIG T_NEWLINE { system("/sbin/ifconfig"); } 
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

char *trimwhitespace(char *str) {
  char *end;

  // Trim leading space
  while(isspace(*str)) str++;

  if(*str == 0)  // All spaces?
    return str;

  // Trim trailing space
  end = str + strlen(str) - 1;
  while(end > str && isspace(*end)) end--;

  // Write new null terminator
  *(end+1) = 0;

  return str;
}

void cd(){
     char cwd[60];
     getcwd(cwd, sizeof(cwd));
     char buffer[60];
     sprintf(buffer, "%s/%s", cwd, yylval.a);
     printf("%s", buffer);
     //char tst[60] = ;
     chdir(trimwhitespace(buffer));
}

int main() {
	yyin = stdin;
    char cwd[60];
    getcwd(cwd, sizeof(cwd));
    printf("Bashinho:%s >> ", cwd);
	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
}
