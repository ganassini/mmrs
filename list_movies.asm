.data
    MOVIES_FILE_NAME:         .asciiz "mmrs/movies.txt"
    SEPARATOR:                .asciiz "+--------+-------------------+---------+----------+-----------+--------+\n"
    HEADER:                   .asciiz "| Título | Ano de lançamento | Duração |  Diretor | Nota IMDB | Status |\n"
    MSG_PRESS_TO_RETURN:      .asciiz "\nPressione qualquer tecla para voltar."
    lineToPrint:              .space 117
    buffer:                   .space 2048

.text
    .globl listMovies
listMovies:
	li      $v0, 4
    la      $a0, SEPARATOR
    syscall

    li      $v0, 4
    la      $a0, HEADER
    syscall

    li      $v0, 4
    la      $a0, SEPARATOR
    syscall

    li      $v0, 13
    la      $a0, MOVIES_FILE_NAME
    li      $a1, 0
    li      $a2, 0
    syscall

    move    $t0, $v0
loop_read:
    li      $v0, 14
    move    $a0, $t0
    la      $a1, buffer
    li      $a2, 2048
    syscall

    beq     $v0, 0, endloop_read
processData:
    la      $t1, buffer
    la      $t2, lineToPrint
    li      $t3, 0
loop_replace:
    lb      $t4, 0($t1)
    beq     $t4, 0, printLine
    beq     $t4, 44, replaceCommaPipe
    beq		$t4, 95, replaceUnderscorePipe
    sb      $t4, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    j       loop_replace
replaceCommaPipe:
	li 		$t5, 32
	sb		$t5, 0($t2)
	addi    $t2, $t2, 1
    li      $t5, 124
    sb      $t5, 0($t2)
    addi	$t2, $t2, 1
    li		$t5, 32
    sb		$t5, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    j       loop_replace
replaceUnderscorePipe:
	li		$t5, 32
	sb		$t5, 0($t2)
	addi	$t2, $t2, 1
	addi	$t1, $t1, 1
	j		loop_replace
printLine:
    sb      $zero, 0($t2)
    li      $v0, 4
    la      $a0, lineToPrint
    syscall

    j       loop_read
endloop_read:
	la $t9, message
	sb $zero, 0($t9)
    li      $v0, 16
    move    $a0, $t0
    syscall
    
    li		$v0, 4
    la 		$a0, SEPARATOR
	syscall
	
	la		$a0, MSG_PRESS_TO_RETURN
	syscall
	
	li		$v0, 12
	syscall

    jr		$ra
