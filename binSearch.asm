
# TP1 Organizacao e Arquitetura de Computadores I
# Clara Davila e Vicente Vivian
#
# OBS: Professor, desculpe qualquer erro nos comentarios. As vezes nos atrapalhamos com as instrucoes.

.text
.globl main

main:
    addi $sp, $sp, -4        # Abre espaco na pilha para A
    la   $s0, A              # Carrega endereco de A
    sw   $s0, 0($sp)         # Armazena na pilha endereco da primeira posicao do vetor  
              

    addi $sp, $sp, -4        # Abre espaco na pilha o primeiro elemento
    la   $a0, msgPrimeiro    # Carrega endereco de msgPrimeiro
    li   $v0, 4              # Impressao da string primeiro
    syscall                  
    li   $v0, 5              # Leitura de valor do primeiro elemento          
    syscall               
    sw   $v0, 0($sp)         # Armazena na pilha o conteudo do primeiro elemento

    addi $sp, $sp, -4        # Abre espaco na pilha para armazenar o ultimo valor
    la   $a0, msgUltimo      # Carrega endereco msgUltimo
    li   $v0, 4              # Impressao da string ultimo
    syscall                  #
    li   $v0, 5              # Leitura de valor do ultimo elemento          
    syscall                  #
    sw   $v0, 0($sp)         # Armazena na pilha endereco do ultimo elemento

    addi $sp, $sp, -4        # Abre espaco na pilha para armazenar o valor
    la   $a0, msgValor       # Carrega endereco de msgValor
    li   $v0, 4              # Impressao da string valor
    syscall                  #
    li   $v0, 5              # Leitura do valor para realizar a busca binaria        
    syscall                  #
    sw   $v0, 0($sp)

    jal  binSearch		     # Pula p/ o label binSearch

    add  $t6, $zero, $v0     # $t6 armazena o resultado que esta em $v0

    la   $a0, resposta       # 
    li   $v0, 4              # Impressao da string resposta
    syscall                  #

    li   $v0, 1              #
    add  $a0, $zero, $t6     # Imprime o indice de resposta
    syscall                  #

    li   $v0, 10             # Encerra o programa
    syscall

binSearch:
    lw   $t0, 0($sp)         # $t0 = valor
    lw   $t2, 4($sp)         # $t2 = ultimo elemento
    lw   $t1, 8($sp)         # $t1 = primeiro elemento
    lw   $t3, 12($sp)        # $t3 = A[1]

    addi $sp, $sp, 16        # Limpa a pilha

    addi $sp, $sp, -4        # Abre espaco na pilha p/ armazenar o ra
    sw   $ra, 0($sp)         # ra serve para poder retornar apos a funcao ser executada

    # if (Prim > Ult)
    bgt	 $t1, $t2, valorNaoExiste	# if (primeiro elemento > ultimo elemento) executa valorNaoExiste
    # else
    add  $t4, $t1, $t2       # meio = primeiro + ultimo | $t4 = $t1 + $t2
    srl  $t4, $t4, 1         # meio = (primeiro + ultimo) / 2 // Deslocamento de bit para realizar divisao, se aproveitando das propriedades dos binarios
    sll  $t5, $t4, 2         # Multiplica meio por 4 utilizando dois deslocamentos de bit para a esquerda para realizar a mudanca de indice
    add  $t5, $t5, $t3       # Adiciona indice de $t5 com indice zero de A
    lw   $t5, 0($t5)         # Carrega conteudo de $t5

        # if (Valor == A[Meio])
        beq	$t0, $t5, valorIgualMeio	# if valor == A[meio] then valorIgualMeio
        # else if (Valor < A[Meio])
        blt	$t0, $t5, valorMenorMeio	# if (Valor<A[Meio]) then valorMenorMeio
        # else // (Valor > A[Meio])
        bgt $t0, $t5, valorMaiorMeio    # if (Valor > A[Meio]) then valorMaiorMeio
    
    jal  binSearch           # Chama a funcao binSearch
    lw   $ra, 0($sp)         # Armazena endereco de retorno
    addi $sp, $sp, 4         # Abre espaco na pilha
    jr   $ra                 # Retorna

valorNaoExiste:  
    addi $v0, $zero, -1      # $v0 recebe -1
    jr   $ra
    
valorIgualMeio:
    add  $v0, $zero, $t4     # $v0 recebe meio
    jr   $ra 

valorMenorMeio:
    # Empilha os valores de acordo com os parametros do metodo a ser chamado
    # (A, Prim, Meio-1, Valor)

    addi $sp, $sp, -4        # Abre espaco na pilha para o A
    sw   $t3, 0($sp)         # Empilha o A
    addi $sp, $sp, -4        # Abre espaco na pilha para para o primeiro elemento
    sw   $t1, 0($sp)         # Empilha primeiro elemento
    addi $sp, $sp, -4        # Abre espaco na pilha para o Meio - 1
    addi $t4, $t4, -1        # Meio - 1 
    sw   $t4, 0($sp)         # Empilha Meio -1
    addi $sp, $sp, -4        # Abre espaco na pilha para valor
    sw   $t0, 0($sp)         # Empilha valor

    jal  binSearch           # Pula p/ busca binaria, faz uso da recursao
    lw   $ra, 0($sp)         # Armazena endereco de retorno que esta na pilha para poder retornar
    addi $sp, $sp, 4         # Realiza o pop na pilha
    jr   $ra                 # Retorna

valorMaiorMeio:
    # Empilha os valores de acordo com os parametros do metodo a ser chamado
    # (A, Meio+1, Ult, Valor)

    addi $sp, $sp, -4        # Abre espaco na pilha para o A
    sw   $t3, 0($sp)         # Empilha o A
    addi $sp, $sp, -4        # Abre espaco na pilha para o Meio + 1
    addi $t4, $t4, 1         # Meio + 1 
    sw   $t4, 0($sp)         # Empilha Meio +1
    addi $sp, $sp, -4        # Abre espaco na pilha para para o ultimo elemento
    sw   $t2, 0($sp)         # Empilha ultimo elemento
    addi $sp, $sp, -4        # Abre espaco na pilha para valor
    sw   $t0, 0($sp)         # Empilha valor

    jal  binSearch           # Pula p/ busca binaria, faz uso da recursao
    lw   $ra, 0($sp)         # Armazena endereco de retorno que esta na pilha para poder retornar
    addi $sp, $sp, 4         # Realiza o pop na pilha
    jr   $ra                 # Retorna

.data

A: .word -5 -1 5 9 12 15 21 29 31 58 250 325

msgPrimeiro: .asciiz "Informe o indice de inicio da busca: "
msgUltimo:   .asciiz "\nInforme o indice de fim da busca: "
msgValor:    .asciiz "\nInforme o valor a ser buscado: "
resposta:    .asciiz "\nIndice no qual se encontra o valor buscado: "
