# compiladores 2022.2
 
# Analisador léxico
```
flex src/lexico/lexico &&
gcc lex.yy.c &&
./a.out < teste/input
```

# Analisador sintático
```
sintatico.sh
```