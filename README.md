![](src/misc/its%20simple.gif)
# Projeto da disciplina de Compiladores 2022.2

Projeto da disciplina de Compiladores da UnB em 2022.2

Universidade de Brasília, Instituto de Ciências Exatas, Departamento de Ciência da Computação.

Desenvolvido por: [Guilherme Silva Souza](https://github.com/gss214), [Gustavo Tomas](https://github.com/gustavo-tomas) e [Maria Eduarda Machado de Holanda](https://github.com/dudaholandah).

Linguagem utilizada: C.

# Descrição

Esse projeto foi feito com apoio do Bison e Yacc. O Bison e Yacc são ferramentas que ajudam a gerar analisadores léxicos e sintáticos para aplicações de programação. Essas ferramentas trabalham juntas para facilitar o processo de análise de linguagem para o compilador. Foi seguido os seguintes passos para desenvover o projeto. 

# Análisador Léxico

O analisador léxico é uma etapa importante do processo de compilação, onde é responsável por identificar e classificar os tokens (sequências de caracteres) de uma entrada (geralmente um programa escrito em alguma linguagem de programação). O resultado da análise léxica é uma lista de tokens, cada um com um tipo e um valor associado, que será usada como entrada para a próxima etapa, a análise sintática.

O projeto utiliza a biblioteca Flex para gerar o analisador léxico. A definição dos tokens é feita com expressões regulares e no arquivo de entrada. Por exemplo, essa expressão regular define um token para um número inteiro:

``` 
NUMBER_INTEGER             	{SIGN}?{DIGIT}+
```

A ação associada a cada token é uma operação C que será executada quando o token for encontrado na entrada. Por exemplo, a ação para o token NUMBER_INTEGER é retornar o valor inteiro convertido de yytext (texto atualmente sendo processado), utilizando a função atoi():

```
{NUMBER_INTEGER}			{yylval.intval = atoi(yytext); return NUMBER_INTEGER;}
```

A função yywrap() é uma função opcional que é chamada pelo Flex quando o fim da entrada é alcançado. Neste caso, a função simplesmente retorna 1 para indicar que não há mais nada a ser processado.

Em resumo, o analisador léxico é responsável por reconhecer e classificar os tokens de uma entrada de acordo com as expressões regulares definidas.
# Analisador Sintático

O analisador sintático é um componente do compilador que analisa a sintaxe do programa. É responsável por verificar se a estrutura da linguagem usada no programa é válida, ou seja, se está de acordo com as regras da linguagem de programação. O analisador sintático verifica se a ordem das palavras, os tipos de dados, as estruturas de controle de fluxo e outros elementos estão de acordo com as regras definidas na linguagem.

No projeto é utilizada uma gramática para o analisador sintático escrito em Bison, que é uma ferramenta para gerar analisadores sintáticos. A gramática descreve a estrutura sintática da linguagem de programação e define como os elementos do programa se relacionam uns com os outros. A gramática especifica regras para identificar as estruturas da linguagem, como por exemplo, a declaração de variáveis, as instruções de controle de fluxo e as operações aritméticas. O analisador sintático usa a gramática para analisar o programa e verificar se a sintaxe está correta.

# Gramática 

Usamos como base a gramática do [simple](src/misc/Compiler%20Construction%20using%20Flex%20and%20Bison.pdf) fazendo modificações para novas regras.

A gramática é escrita no formato BNF (Backus-Naur Form) e está dividida em regras. Cada regra representa uma síntese da linguagem e define a estrutura de uma construção válida na linguagem. A regra inicial é program, que representa o programa completo. É definido uma série de tipos de token, como inteiros, floats, identificadores, operadores, etc. Esses tipos são utilizados na definição das regras para especificar a estrutura dos elementos sintáticos válidos. Além disso, a gramática também define regras para a precedência de operações, como `<` e `=`, que são regras de precedência de esquerda.

Na gramática, as operações em notação polonesa são realizadas através de uma pilha de operações. A pilha é inicialmente populada com os operandos da expressão e, em seguida, é usada para armazenar os operadores conforme eles são encontrados na expressão. Cada vez que um operador é encontrado, ele é retirado da pilha e os dois operandos mais recentes da pilha são combinados com ele, resultando em um novo operando que é adicionado de volta à pilha. Este processo é repetido até que todos os operadores tenham sido avaliados e a pilha contenha apenas um operando, que é o resultado da expressão.

A vantagem da notação polonesa é que ela permite a avaliação da expressão sem a necessidade de parênteses ou de uma análise sintática complexa, tornando o processo de avaliação mais simples e mais eficiente. Além disso, a notação polonesa também é útil para a construção de compiladores e interpretadores, pois facilita a geração de código objeto e a interpretação do código fonte.

<details>
    <summary>Gramática Completa do Compilador</summary>

<div markdown=1>

```
program:        LET declarations IN commands END

declarations:   /* empty */                                     
                | declarations INTEGER id_seq IDENTIFIER ';'    
                | declarations FLOAT id_seq IDENTIFIER ';'      
                
id_seq:         /* empty */
                | id_seq IDENTIFIER ','                         
                
commands:       /* empty */
                | commands command ';'                               

command:        SKIP
                | READ IDENTIFIER                               
                | READ_FT IDENTIFIER                            
                | WRITE exp                                     
                | WRITE_FT exp                                  
                | IDENTIFIER ASSGNOP exp                        
                | IF exp THEN commands ELSE commands END
                | WHILE exp DO commands END                                          

exp:            NUMBER_INTEGER                                  
                | NUMBER_FLOAT                                  
                | IDENTIFIER                                    
                | exp exp '<'                                   
                | exp exp '='                                   
                | exp exp '>'                                   
                | exp exp '+'                                   
                | exp exp '-'                                   
                | exp exp '*'                                   
                | exp exp '/'                                   
                | exp exp '^'
                | '(' exp ')'
```
</div>
<br>
</details>

# Tabela de Simbolos
A tabela de símbolos é uma estrutura de dados que armazena informações sobre identificadores (nomes de variáveis, constantes, etc.) em um programa. A tabela é implementada como uma lista ligada (linked list) e é composta por elementos do tipo symrec, que são registros (structs) com três campos: name (nome do símbolo), offset (deslocamento dos dados) e next (ponteiro para o próximo elemento da lista).

A função `putsym` é usada para adicionar um novo símbolo à tabela. Ela aloca um novo elemento da lista, inicializa seus campos e adiciona-o ao início da lista. A função `getsym` é usada para procurar um símbolo na tabela. Ela percorre a lista e retorna o primeiro elemento que possui o nome dado. Se o símbolo não for encontrado, a função retorna 0. A função `clear_table` é usada para esvaziar a tabela. Ela é chamada recursivamente para liberar a memória alocada para cada elemento da lista.

A tabela de símbolos é uma ferramenta útil para compiladores, interpretes e outras ferramentas de linguagem de programação, pois permite acessar informações sobre identificadores de forma eficiente durante a execução do programa.

# Stack Machine e Geração do Código Objeto

A Stack Machine é uma arquitetura de computadores baseada na ideia de uma pilha de dados, na qual as operações são realizadas em cima dos dados presentes na pilha. A implementação escolhida foi uma máquina de pilha em C. A máquina tem registradores especiais, como o Registrador de Instrução (IR), Registrador de Endereço de Programa (PC) e Registrador de Topo da Pilha (Top). Além disso, há a pilha de dados, onde são armazenados os valores e tipos das variáveis.

A máquina funciona com ciclos de busca e execução, onde a busca consiste em carregar a próxima instrução do programa para o IR e a execução consiste em realizar a operação indicada pela instrução. A máquina tem diversas operações, como `HALT` (parada), `READ_INT` (leitura de inteiro), `READ_FLOAT` (leitura de número flutuante), `STORE` (armazenamento), entre outras.

As operações são realizadas de acordo com as instruções presentes no código e os valores são manipulados na pilha de dados. Por exemplo, a operação `STORE` pega o valor do topo da pilha e o armazena na posição indicada pelo argumento da instrução.

O resultado das operações é escrito em um arquivo de saída, `out/object.ogui`, no qual são escritos o endereço da instrução, o nome da operação e o valor do argumento. Ao final, a máquina para sua execução quando é encontrada a instrução HALT.


# Instruções para compilar e rodar o projeto

Para compilar é só usar o comando `make` e para rodar algum programa da pasta `tests` use o comando `./Run tests/{programa}`

# Exemplos de Programas


## Fatorial
```
let // area de declaracoes
    integer a, inc, fat; // declaracoes de inteiro
in
    inc := 1; // atribuicao
    fat := 1;
    read a; // leitura de inteiro

    while (inc a <) do // iteracao
        fat := fat inc *;
        inc := inc 1 +;
    end;

    fat := fat a *;
    write fat; // escrita de inteiro
end

```
<details>
    <summary>Código Objeto</summary>

<div markdown=1>

```
Input:

a = 5
```

```
 0: data        3
 1: ld_int      1
 2: store       2
 3: ld_int      1
 4: store       3
 5: in_int      1
 6: ld_var      2
 7: ld_var      1
 8: lt          0
 9: jmp_false   19
10: ld_var      3
11: ld_var      2
12: mult        0
13: store       3
14: ld_var      2
15: ld_int      1
16: add         0
17: store       2
18: goto        6
 6: ld_var      2
 7: ld_var      1
 8: lt          0
 9: jmp_false   19
10: ld_var      3
11: ld_var      2
12: mult        0
13: store       3
14: ld_var      2
15: ld_int      1
16: add         0
17: store       2
18: goto        6
 6: ld_var      2
 7: ld_var      1
 8: lt          0
 9: jmp_false   19
10: ld_var      3
11: ld_var      2
12: mult        0
13: store       3
14: ld_var      2
15: ld_int      1
16: add         0
17: store       2
18: goto        6
 6: ld_var      2
 7: ld_var      1
 8: lt          0
 9: jmp_false   19
10: ld_var      3
11: ld_var      2
12: mult        0
13: store       3
14: ld_var      2
15: ld_int      1
16: add         0
17: store       2
18: goto        6
 6: ld_var      2
 7: ld_var      1
 8: lt          0
 9: jmp_false   19
19: ld_var      3
20: ld_var      1
21: mult        0
22: store       3
23: ld_var      3
24: out_int     0
25: halt        0
```
</div>
</details>

## Bhaskara

``` 
let
    float a, b, c, delta, raiz_delta, x1, x2;
in
    read_ft a; // leitura de float
    read_ft b;
    read_ft c;

    delta := b b * 4 a * c * -;

    if (delta 0 <) then // condicional
        write -99999;
    else 
        raiz_delta := delta 0.5 ^;
        x1 := b -1 * raiz_delta + 2 a * /;
        x2 := b -1 * raiz_delta - 2 a * /;
        write_ft x1; // escrita de float
        write_ft x2;
    end;
end
```

<details>
    <summary>Código Objeto</summary>

<div markdown=1>


```
Input:
a = 1
b = -5
c = 6
```

```
 0: data        7
 1: in_float    1
 2: in_float    2
 3: in_float    3
 4: ld_var      2
 5: ld_var      2
 6: mult        0
 7: ld_int      4
 8: ld_var      1
 9: mult        0
10: ld_var      3
11: mult        0
12: sub         0
13: store       4
14: ld_var      4
15: ld_int      0
16: lt          0
17: jmp_false   21
21: ld_var      4
22: ld_float    0.500000
23: pwr         0
24: store       5
25: ld_var      2
26: ld_int      -1
27: mult        0
28: ld_var      5
29: add         0
30: ld_int      2
31: ld_var      1
32: mult        0
33: div         0
34: store       6
35: ld_var      2
36: ld_int      -1
37: mult        0
38: ld_var      5
39: sub         0
40: ld_int      2
41: ld_var      1
42: mult        0
43: div         0
44: store       7
45: ld_var      6
46: out_float   0
47: ld_var      7
48: out_float   0
49: halt        0
```

</div>
</details>
