.data
	MOVIES_FILE_NAME: 		.asciiz "mmrs/movies.txt"
	SEPARATOR: 				.asciiz "+--------+---------+-------------------+---------+-----------+--------+\n"
    HEADER: 				.asciiz "| Título | Diretor | Ano de lançamento | Duração | Nota IMDB | Status |\n"
    PROMPT_MOVIE_TITLE: 	.asciiz "Título do filme: "
    MSG_PRESS_TO_RETURN: 	.asciiz "\nPressione qualquer tecla para voltar."
	MSG_MOVIE_NOT_FOUND: 	.asciiz "Filme não encontrado."
	movieToSearch: 	.space 48 
	lineToPrint:	.space 100
	buffer: 		.space 2048    
	newline: 		.asciiz "\n"                                                 
.text
	.globl findMovie
findMovie: 
    li 		$v0, 4
	la 		$a0, PROMPT_MOVIE_TITLE
	syscall
	
	li 		$v0, 8
	la 		$a0, movieToSearch
	li 		$a1, 48
	syscall
	
	# format title
	la 		$t0, movieToSearch 
loop_formatTitle:
	lb 		$t1, 0($t0)
	beq 	$t1, 10, compareStrings
	beq 	$t1, 32, spaceToUnderscore
	blt 	$t1, 97, upperToLower
	addi 	$t0, $t0, 1
	j 		loop_formatTitle
upperToLower:
	addi 	$t1, $t1, 32
	sb 		$t1, 0($t0)
	addi 	$t0, $t0, 1
	j 		loop_formatTitle
spaceToUnderscore:
	li 		$t2, 95
	sb 		$t2, 0($t0) 
	addi 	$t0, $t0, 1
	j 		loop_formatTitle
compareStrings:
    li      $v0, 13
    la      $a0, MOVIES_FILE_NAME
    li      $a1, 0
    li      $a2, 0
    syscall
    
    move    $t0, $v0
    li      $v0, 14
    move    $a0, $t0
    la      $a1, buffer
    li      $a2, 2048
    syscall

	move    $t1, $v0
    li      $v0, 16
    move    $a0, $t0
    syscall

    la      $t0, buffer
    la		$t1, buffer
    la      $t2, movieToSearch                                        
loop_compareTitle:
    lb      $t3, 0($t1)
    lb 		$t4, 0($t2)
    beqz    $t3, movieNotFound
    beq		$t3, 44, movieFound
    bne     $t3, $t4, loop_nextLine
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    j       loop_compareTitle
loop_nextLine:
    lb      $t3, 0($t1)
    beq     $t3, 10, endloop_nextLine
    addi    $t1, $t1, 1
    j       loop_nextLine
endloop_nextLine:
    addi    $t1, $t1, 1
loop_nextLineT0:
	lb      $t5, 0($t0)
    beq     $t5, 10, endloop_nextLineT0
    addi    $t0, $t0, 1
    j       loop_nextLineT0
endloop_nextLineT0:
	addi    $t0, $t0, 1
    j       loop_compareTitle
movieFound:
	la 		$t6, lineToPrint
	li		$t7, 124
	sb		$t7, 0($t6)
	addi	$t6, $t6, 1
	li		$t7, 32
	sb 		$t7, 0($t6)
	addi	$t6, $t6, 1
	lb		$t7, 0($t0)
	addi 	$t7, $t7, -32
	sb		$t7, 0($t6)
	addi	$t0, $t0, 1
	addi	$t6, $t6, 1
loop_printToLineBuffer:
	lb 		$t7, 0($t0)
	beq		$t7, 10, endloop_printToLineBuffer
	beq		$t7, 95, printSpaceToLineBuffer
	beq		$t7, 44, printDivisionToLineBuffer
	sb 		$t7, 0($t6)
	addi	$t0, $t0, 1
	addi 	$t6, $t6, 1
	j		loop_printToLineBuffer
printSpaceToLineBuffer:
	li		$t7, 32
	sb		$t7, 0($t6)
	addi	$t0, $t0, 1
	addi	$t6, $t6, 1
	lb		$t7, 0($t0)
	addi 	$t7, $t7 -32
	sb 		$t7, 0($t6)
	addi 	$t0, $t0, 1
	addi	$t6, $t6, 1
	j		loop_printToLineBuffer
printDivisionToLineBuffer:
	li 		$t7, 32
	sb 		$t7, 0($t6)
	addi 	$t6, $t6, 1
	li 		$t7, 124
	sb		$t7, 0($t6)
	addi 	$t6, $t6, 1
	li 		$t7, 32
	sb		$t7, 0($t6)
	addi	$t6, $t6, 1
	addi	$t0, $t0, 1
	j		loop_printToLineBuffer
endloop_printToLineBuffer:
	la $t9, message
	sb $zero, 0($t9)
	li      $v0, 4
    la      $a0, SEPARATOR
    syscall

    li      $v0, 4
    la      $a0, HEADER
    syscall

    li      $v0, 4
    la      $a0, SEPARATOR
    syscall

	li		$t7, 32
	sb		$t7, 0($t6)
	li 		$t7, 124
	sb		$t7, 1($t6)
	li		$t7, 10
	sb 		$t7, 2($t6)
	sb		$zero, 3($t6)
	li		$v0, 4
	la		$a0, lineToPrint
	syscall
	
	la 		$a0, SEPARATOR
	syscall
	
	la		$a0, MSG_PRESS_TO_RETURN
	syscall
	
	li		$v0, 12
	syscall
	
	jr		$ra
movieNotFound:
	la 		$t0, MSG_MOVIE_NOT_FOUND
	la 		$t1, message
loop_movieNotFound:
	lb 		$t2, 0($t0)
	beqz 	$t2, endloop_movieNotFound
	sb 		$t2, 0($t1)
	addi 	$t0, $t0, 1
	addi 	$t1, $t1, 1
	j 		loop_movieNotFound
endloop_movieNotFound:
	sb 		$t2, 0($t1)
	
	jr 		$ra
	
	
