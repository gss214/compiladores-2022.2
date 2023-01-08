flex src/lexico/lexico.l &&
yacc -d src/sintatico/sintatico.y &&
gcc lex.yy.c y.tab.c &&
./a.out < teste/myprog.gui