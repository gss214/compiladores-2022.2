# compiladores 2022.2
 
# Analisador léxico
```
flex src/lexico/lexico-v0.l &&
gcc lex.yy.c &&
./a.out < teste/input
```