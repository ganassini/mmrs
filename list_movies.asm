.data
    MOVIES_FILE_NAME: 		.asciiz "mmrs/movies.txt"
    SEPARATOR: 				.asciiz "+----------------------------------------+------------------------+---------------------+-------------+-------------+---------------+\n"
    HEADER: 				.asciiz    "|                 Título                 |         Diretor        |  Ano de lançamento  |   Duração   |  Nota IMDB  |     Status    |\n"
    MSG_PRESS_TO_RETURN: 	.asciiz "Pressione qualquer tecla para voltar."
    lineToPrint: 	.space 117
    buffer: 		.space 2048
.text
    .globl listMovies
listMovies:
    li      $v0, 4
    la      $a0, SEPARATOR
    syscall

    la      $a0, HEADER
    syscall

    la      $a0, SEPARATOR
    syscall

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

    li      $v0, 16
    move    $a0, $t0
    syscall
printTitleToLineBuffer:
	li 		$t0, 2
	la      $t1, buffer
	la		$t2, lineToPrint
	li 		$t3, 124
	sb 		$t3, 0($t2)
	addi 	$t2, $t2, 1
	li 		$t3, 32
	sb 		$t3, 0($t2)
	addi 	$t2, $t2, 1
	lb 		$t4, 0($t1)
	addi 	$t4, $t4, -32
	sb 		$t4, 0($t2)
	addi 	$t1, $t1, 1
	addi 	$t2, $t2, 1
loop_printTitleToLineBuffer:
	lb		$t4, 0($t1)
	beq 	$t4, 44, endloop_printTitleToLineBuffer
	beq		$t4, 32, underscoreToSpace
	sb		$t4, 0($t2)
	addi 	$t1, $t1, 1
	addi	$t2, $t2, 1
	addi 	$t0, $t0, 1
	j		loop_printTitleToLineBuffer
underscoreToSpace:
	li 		$t5, 32
	sb 		$t5, 0($t2)
	addi 	$t1, $t1, 1
	addi 	$t2, $t2, 1
	addi	$t0, $t0, 1
	j		loop_printTitleToLineBuffer
endloop_printTitleToLineBuffer:
	beq 	$t0, 41, printDirectorToLineBuffer
	li 		$t9, 32
	sb 		$t9, 0($t2)
	addi	$t2, $t2, 1
	addi 	$t0, $t0, 1
	j 		endloop_printTitleToLineBuffer
printDirectorToLineBuffer:
	li 		$t8, 124
	#addi 	$
	li      $t0, 0
    lb      $t4, 0($t1)
    li      $t3, 32
    sb      $t3, 0($t2)
    addi    $t2, $t2, 1
loop_printDirectorToLineBuffer:
    lb      $t4, 0($t1)
    beq     $t4, 44, printYearToLineBuffer
    beq     $t4, 10, underscoreToSpace
    sb      $t4, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 25, loop_printDirectorToLineBuffer
    j       fillSpaceDirectorToLineBuffer
fillSpaceDirectorToLineBuffer:
    li      $t9, 32
    sb      $t9, 0($t2)
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 26, fillSpaceDirectorToLineBuffer
    j       printYearToLineBuffer
printYearToLineBuffer:
    li      $t0, 0
    lb      $t4, 0($t1)
    li      $t3, 32
    sb      $t3, 0($t2)
    addi    $t2, $t2, 1
loop_printYearToLineBuffer:
    lb      $t4, 0($t1)
    beq     $t4, 44, printDurationToLineBuffer
    sb      $t4, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 5, loop_printYearToLineBuffer
    j       fillSpaceYearToLineBuffer
fillSpaceYearToLineBuffer:
    li      $t9, 32
    sb      $t9, 0($t2)
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 6, fillSpaceYearToLineBuffer
    j       printDurationToLineBuffer
printDurationToLineBuffer:
    li      $t0, 0
    lb      $t4, 0($t1)
    li      $t3, 32
    sb      $t3, 0($t2)
    addi    $t2, $t2, 1
loop_printDurationToLineBuffer:
    lb      $t4, 0($t1)
    beq     $t4, 44, printRatingToLineBuffer
    sb      $t4, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 9, loop_printDurationToLineBuffer
    j       fillSpaceDurationToLineBuffer
fillSpaceDurationToLineBuffer:
    li      $t9, 32
    sb      $t9, 0($t2)
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 10, fillSpaceDurationToLineBuffer
    j       printRatingToLineBuffer
printRatingToLineBuffer:
    li      $t0, 0
    lb      $t4, 0($t1)
    li      $t3, 32
    sb      $t3, 0($t2)
    addi    $t2, $t2, 1
loop_printRatingToLineBuffer:
    lb      $t4, 0($t1)
    beq     $t4, 44, printStatusToLineBuffer
    sb      $t4, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 5, loop_printRatingToLineBuffer
    j       fillSpaceRatingToLineBuffer
fillSpaceRatingToLineBuffer:
    li      $t9, 32
    sb      $t9, 0($t2)
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 6, fillSpaceRatingToLineBuffer
    j       printStatusToLineBuffer
printStatusToLineBuffer:
    li      $t0, 0
    lb      $t4, 0($t1)
    li      $t3, 32
    sb      $t3, 0($t2)
    addi    $t2, $t2, 1
loop_printStatusToLineBuffer:
    lb      $t4, 0($t1)
    beq     $t4, 10, printLine
    sb      $t4, 0($t2)
    addi    $t1, $t1, 1
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 13, loop_printStatusToLineBuffer
    j       fillSpaceStatusToLineBuffer
fillSpaceStatusToLineBuffer:
    li      $t9, 32
    sb      $t9, 0($t2)
    addi    $t2, $t2, 1
    addi    $t0, $t0, 1
    blt     $t0, 14, fillSpaceStatusToLineBuffer
printLine:
    li      $v0, 4
    la      $a0, lineToPrint
    syscall
	
    
