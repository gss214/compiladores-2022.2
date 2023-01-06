# compiladores 2022.2
 
# Analisador léxico
```
flex src/lexico/lexico-v0.l &&
gcc lex.yy.c &&
./a.out < teste/input
```

# Analisador sintático
```
yacc -d sintatico.y &&
flex lexico-v0.l &&
gcc lex.yy.c y.tab.c -o compile && 
./compile < myprog.gui
```