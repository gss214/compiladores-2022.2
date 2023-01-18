# compiladores 2022.2
 
# Analisador léxico
```
flex src/lexico/lexico.l &&
gcc lex.yy.c &&
./a.out < teste/input
```

# Analisador sintático
```
make && ./Run test/prog.gui
```

## Testes unitários
```
make -B test && ./Test
```
