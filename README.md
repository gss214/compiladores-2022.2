# compiladores 2022.2
 
# Analisador léxico
```
flex src/lexico/lexico.l &&
gcc lex.yy.c &&
./a.out < teste/input
```

# Analisador sintático
```
sintatico.sh
```