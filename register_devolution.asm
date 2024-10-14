.data
	MOVIES_FILE_NAME:		.asciiz "mmrs/movies.txt"
	CLIENTS_FILE_NAME: 		.asciiz "mmrs/clients.txt"
	PROMPT_MOVIE_TITLE: 	.asciiz "Titulo do filme que deseja devolver: "
	PROMPT_CLIENT_NAME: 	.asciiz "Nome do cliente: "
	MSG_CLIENT_NOT_FOUND: 	.asciiz "Cliente não encontrado."
	MSG_CLIENT_NOT_RENTED:		.asciiz "Cliente não possui nenhum filme alugado."
	MSG_MOVIE_NOT_FOUND: 	.asciiz "Filme não encontrado."
	MSG_MOVIE_NOT_RENTED:	.asciiz "Filme não está alugado."
	MSG_SUCCESS: 			.asciiz "Devolução registrada com sucesso."
	MSG_PARABENS:			.asciiz "this is elon musk"
	title: 			.space 48
	clientName: 	.space 48
	moviesBuffer: 	.space 2048
	clientsBuffer:  .space 2048
.text
	.globl registerDevolution
registerDevolution:
	li 		$v0, 4
	la 		$a0, PROMPT_CLIENT_NAME
	syscall
	
	li 		$v0, 8
	la 		$a0, clientName
	li 		$a1, 48
	syscall
	
	# format title
	la 		$t0, clientName 
	
loop_formatName:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, checkClientExists
	beq 	$s1, 32, spaceToUnderscoreName
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
    
    move    $t0, $v0
    
    li      $v0, 14
    move    $a0, $t0
    la      $a1, clientsBuffer
    li      $a2, 2048
    syscall

	move    $t1, $v0
    li      $v0, 16
    move    $a0, $t0
    syscall

    la      $t0, clientsBuffer
    la      $t1, clientName
loop_checkClientExists:
    lb      $t2, 0($t0)
    lb 		$t3, 0($t1)
    beqz    $t2, clientNotFound
    beq		$t2, 44, clientFound
    bne     $t2, $t3, loop_nextLineClient
    addi    $t0, $t0, 1
    addi    $t1, $t1, 1
    j       loop_checkClientExists
loop_nextLineClient:
    lb      $t2, 0($t0)
    beq     $t2, 10, endloop_nextLineClient
    addi    $t0, $t0, 1
    j       loop_nextLineClient
endloop_nextLineClient:
    addi    $t0, $t0, 1
    j       loop_checkClientExists
clientNotFound:
    la 		$t0, MSG_CLIENT_NOT_FOUND
	la 		$t1, message
loop_clientNotFound:
	lb 		$t2, 0($t0)
	beqz 	$t2, endloop_clientNotFound
	sb 		$t2, 0($t1)
	addi 	$t0, $t0, 1
	addi 	$t1, $t1, 1
	j 		loop_clientNotFound
endloop_clientNotFound:
	sb 		$t2, 0($t1)
	
	jr 		$ra
clientFound:
	li 		$t9, 0
loop_clientFound:
	lb 		$t2, 0($t0)
	beq 	$t2, 44, commaFoundClient
	addi 	$t0, $t0, 1
	j		loop_clientFound
commaFoundClient:
	addi 	$t9, $t9, 1
	addi 	$t0, $t0, 1
	beq		$t9, 3, checkNone
	j		loop_clientFound
checkNone:
    lb      $t2, 0($t0)
    bne     $t2, 110, movieTitle
    li      $v0, 4
	la 		$s0, MSG_CLIENT_NOT_RENTED
	la 		$s1, message
loop_clientNotRented:
	lb 		$s2, 0($s0)
	beqz 	$s2, endloop_clientNotRented
	sb 		$s2, 0($s1)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_clientNotRented
endloop_clientNotRented:
	sb 		$s2, 0($s1)
	
	jr 		$ra
	
movieTitle:
	li 		$v0, 4
	la 		$a0, PROMPT_MOVIE_TITLE
	syscall
	
	li 		$v0, 8
	la 		$a0, title
	li 		$a1, 48
	syscall
	
	# format title
	la 		$t0, title 
loop_formatTitle:
	lb 		$t1, 0($t0)
	beq 	$t1, 10, checkMovieExists
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
checkMovieExists:
    li      $v0, 13
    la      $a0, MOVIES_FILE_NAME
    li      $a1, 0
    li      $a2, 0
    syscall
    
    move    $t0, $v0
    
    li      $v0, 14
    move    $a0, $t0
    la      $a1, moviesBuffer
    li      $a2, 2048
    syscall

	move    $t1, $v0
    li      $v0, 16
    move    $a0, $t0
    syscall

    la      $t0, moviesBuffer
    la      $t1, title
loop_checkMovieExists:
    lb      $t2, 0($t0)
    lb 		$t3, 0($t1)
    beqz    $t2, movieNotFound
    beq		$t2, 44, movieFound
    bne     $t2, $t3, loop_nextLine
    addi    $t0, $t0, 1
    addi    $t1, $t1, 1
    j       loop_checkMovieExists
loop_nextLine:
    lb      $t2, 0($t0)
    beq     $t2, 10, endloop_nextLine
    addi    $t0, $t0, 1
    j       loop_nextLine
endloop_nextLine:
    addi    $t0, $t0, 1
    j       loop_checkMovieExists
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
movieFound:
	li 		$t9, 0
loop_movieFound:
	lb 		$t2, 0($t0)
	beq 	$t2, 44, commaFound
	addi 	$t0, $t0, 1
	j		loop_movieFound
commaFound:
	addi 	$t9, $t9, 1
	addi 	$t0, $t0, 1
	beq		$t9, 5, checkAvailability
	j		loop_movieFound
checkAvailability:
    lb      $t2, 0($t0)
    bne     $t2, 100, devolutionMovie
    li      $v0, 4
	la 		$s0, MSG_MOVIE_NOT_RENTED
	la 		$s1, message
loop_movieNotRented:
	lb 		$s2, 0($s0)
	beqz 	$s2, endloop_movieNotRented
	sb 		$s2, 0($s1)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_movieNotRented
endloop_movieNotRented:
	sb 		$s2, 0($s1)
	
	jr 		$ra
	
devolutionMovie:
    li      $t2, 97             
    sb      $t2, 0($t0)         

    
    la      $t0, MSG_SUCCESS
    la      $t1, message        
    jal     message             

    
    li      $v0, 13             
    la      $a0, MOVIES_FILE_NAME
    li      $a1, 1              
    li      $a2, 0
    syscall
    move    $t0, $v0            

    li      $v0, 15            
    move    $a0, $t0            
    la      $a1, moviesBuffer  
    li      $a2, 2048           
    syscall

    li      $v0, 16             
    move    $a0, $t0
    syscall

    
    la      $t0, MSG_PARABENS
    la      $t1, message        
    jal     message             

    jr      $ra 
    
message:
    li      $v0, 4            
    la      $a0, message      
    syscall                   
    jr      $ra