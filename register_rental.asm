.data
	MOVIES_FILE_NAME:		.asciiz "mmrs/movies.txt"
	CLIENTS_FILE_NAME: 		.asciiz "mmrs/clients.txt"
	PROMPT_MOVIE_TITLE: 	.asciiz "Titulo do filme: "
	PROMPT_CLIENT_NAME: 	.asciiz "Nome do cliente: "
	MSG_CLIENT_NOT_FOUND: 	.asciiz "Cliente não encontrado."
	MSG_MOVIE_NOT_FOUND: 	.asciiz "Filme não encontrado."
	MSG_MOVIE_RENTED:		.asciiz "Filme já está alugado."
	MSG_SUCCESS: 			.asciiz "Locação registrada com sucesso."
	rented:					.asciiz "alugado"
	title: 		.space 48
	clientName: .space 48
	buffer: 	.space 2048
.text
	.globl registerRental
registerRental:
	li 		$v0, 4
	la 		$a0, PROMPT_MOVIE_TITLE
	syscall
	
	li 		$v0, 8
	la 		$a0, title
	li 		$a1, 48
	syscall
	# format title
	la 		$s0, title 
loop_formatTitle:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, checkMovieAvailability
	beq 	$s1, 32, spaceToUnderscore
	blt 	$s1, 97, upperToLower
	addi 	$s0, $s0, 1
	j 		loop_formatTitle
upperToLower:
	addi 	$s1, $s1, 32
	sb 		$s1, 0($s0)
	addi 	$s0, $s0, 1
	j 		loop_formatTitle
spaceToUnderscore:
	li 		$s2, 95
	sb 		$s2, 0($s0) 
	addi 	$s0, $s0, 1
	j 		loop_formatTitle
checkMovieExists:
    li      $v0, 13
    la      $a0, MOVIES_FILE_NAME
    li      $a1, 0
    li      $a2, 0
    syscall
    
    li      $v0, 14
    move    $a0, $t0
    la      $a1, buffer
    li      $a2, 2048
    syscall

    bltz    $v0, movieNotFound
    move    $t1, $v0
    li      $v0, 16
    move    $a0, $t0
    syscall

    la      $t0, buffer
    la      $t1, title
loop_findMovie:
    lb      $t2, 0($t0)
    beqz    $t2, movieNotFound
    beq     $t2, 10, loop_nextLine
    lb      $t3, 0($t1)
    beqz    $t3, checkComma
    bne     $t2, $t3, loop_nextLine
    addi    $t0, $t0, 1
    addi    $t1, $t1, 1
    j       loop_findMovie
checkComma:
    lb      $t2, 0($t0)
    beq     $t2, 44, movieFound
    j       loop_nextLine
loop_nextLine:
    lb      $t2, 0($t0)
    beqz    $t2, movieNotFound
    beq     $t2, 10, endloop_nextLine
    addi    $t0, $t0, 1
    j       loop_nextLine
endloop_nextLine:
    addi    $t0, $t0, 1
    j       loop_findMovie
movieNotFound:
    li      $v0, 4
    la      $a0, MSG_MOVIE_NOT_FOUND
    syscall
    
    jr      $ra
movieFound:
	li 		$t9, 0
loop_movieFound:
	lb 		$t2, 0($t0)
	beq 	$t2, 44, commaFound
	addi 	$t0, $t0, 1
	j		loop_movieFound
commaFound:
	addi 	$t9, $t9, 1
	beq		$t9, 4, checkMovieAvailability
	j		loop_movieFound
checkAvailability:
	
loop_checkAvailability:

getClientName:
	li 		$v0, 4
	la 		$a0, PROMPT_CLIENT_NAME
	syscall
	
	li 		$v0, 8
	la 		$a0, clientName
	li 		$a1, 48
	syscall
	# format name
	la 		$s0, clientName 
loop_formatName:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, checkClientExists
	beq 	$s1, 32, spaceToUnderscore
	blt 	$s1, 97, upperToLowerName
	addi 	$s0, $s0, 1
	j 		loop_formatName
upperToLowerName:
	addi 	$s1, $s1, 32
	sb 		$s1, 0($s0)
	addi 	$s0, $s0, 1
	j 		loop_formatName
spaceToUnderscoreName:
	li 		$s2, 95
	sb 		$s2, 0($s0) 
	addi 	$s0, $s0, 1
	j 		loop_formatName
checkClientExists:
	li      $v0, 13
    la      $a0, CLIENTS_FILE_NAME
    li      $a1, 0
    li      $a2, 0
    syscall
    
    li      $v0, 14
    move    $a0, $t0
    la      $a1, buffer
    li      $a2, 2048
    syscall

    bltz    $v0, clientNotFound
    move    $t1, $v0
    li      $v0, 16
    move    $a0, $t0
    syscall

    la      $t0, buffer
    la      $t1, title
loop_findClient:
    lb      $t2, 0($t0)
    beqz    $t2, clientNotFound
    beq     $t2, 10, loop_nextLine
    lb      $t3, 0($t1)
    beqz    $t3, checkCommaClient
    bne     $t2, $t3, loop_nextLine
    addi    $t0, $t0, 1
    addi    $t1, $t1, 1
    j       loop_findClient
checkCommaClient:
    lb      $t2, 0($t0)
    beq     $t2, 44, clientFound
    j       loop_nextLine
loop_nextLineClient:
    lb      $t2, 0($t0)
    beqz    $t2, clientNotFound
    beq     $t2, 10, endloop_nextLineClient
    addi    $t0, $t0, 1
    j       loop_nextLine
endloop_nextLineClient:
    addi    $t0, $t0, 1
    j       loop_findClient
clientNotFound:
    li      $v0, 4
    la      $a0, MSG_CLIENT_NOT_FOUND
    syscall
    
    jr      $ra
clientFound:
	