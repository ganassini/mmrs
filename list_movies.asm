.data
	MOVIES_FILE_NAME: .asciiz "mmrs/movies.txt"
	SEPARATOR: .asciiz "+----------------------------------------+------------------------+---------------------+-------------+-------------+\n"
	HEADER: .asciiz "|                 Título                 |         Diretor        |  Ano de lançamento  |   Duração   |  Nota IMDB  |\n"
	LINE_START: .asciiz "| "
	MSG_KEY_TO_RETURN: .asciiz "Pressione qualquer tecla para voltar."
	lineToPrint: .space 1016
	buffer:.space 2048
.text
	.globl listMovies
listMovies:
	li 		$v0, 4
	la 		$a0, SEPARATOR
	syscall
	
	la $a0, HEADER
	syscall
	
	la $a0, SEPARATOR
	syscall
	
	li 		$v0, 13
	la 		$a0, MOVIES_FILE_NAME
	li 		$a1, 0
	li 		$a2, 0
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

    la      $t2, buffer
    la      $t3, buffer
print_loop:
	li 		$a0, 124
    lb      $t4, 0($t3)
    beq     $t4, $zero, return


    li      $t5, 10
    beq     $t4, $t5, print_line

    addi    $t3, $t3, 1
    j       print_loop

print_line:
    sb      $zero, 0($t3)

    li      $v0, 4
    move    $a0, $t2
    syscall

    li      $t4, 10
    sb      $t4, 0($t3)

    addi    $t3, $t3, 1
    move    $t2, $t3

    li      $v0, 4
    la      $a0, newline
    syscall

    j       print_loop

return:
	la $t0, message
	sb $zero, 0($t0)
	
	jr $ra