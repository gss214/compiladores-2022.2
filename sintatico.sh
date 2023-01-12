flex -o build/lexico.c src/lexico/lexico.l &&
yacc -o build/sintatico.c -d src/sintatico/sintatico.y &&
gcc src/main.c build/lexico.c build/sintatico.c -o Run &&
./Run $1