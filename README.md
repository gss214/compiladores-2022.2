# compiladores 2022.2
 
# Analisador léxico
```
flex src/lexico/lexico &&
gcc lex.yy.c &&
./a.out < teste/input
```

# Analisador sintático
```
flex src/lexico/lexico.l && yacc -d src/sintatico/sintatico.y
gcc lex.yy.c y.tab.c
./a.out
```