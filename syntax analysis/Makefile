parser: y.tab.c lex.yy.c y.tab.h
	gcc -w -g y.tab.c -ldl -ll -o parser
lex.yy.c: lex.l
	lex lex.l
y.tab.c: parser.y
	yacc -v -d -g parser.y
clean:
	rm -f parser y.tab.c lex.yy.c y.tab.h y.output
