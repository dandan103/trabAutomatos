all: bash

bash.tab.c bash.tab.h:	bash.y
	bison -d bash.y

lex.yy.c: bash.l bash.tab.h
	flex bash.l

bash: lex.yy.c bash.tab.c bash.tab.h
	gcc -o bash bash.tab.c lex.yy.c -lfl

clean:
	rm bash bash.tab.c lex.yy.c bash.tab.h
