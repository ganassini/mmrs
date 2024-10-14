.data
	CLIENTS_FILE_NAME: 	.asciiz "mmrs/clients.txt"
	PROMPT_NAME: 		.asciiz "Nome: "
	PROMPT_PHONENUMBER: .asciiz "Celular: "
	PROMPT_EMAIL: 		.asciiz "Email: "
	MSG_CLIENT_ADDED: 	.asciiz "Cliente adicionado com sucesso."
	MSG_PHONE_HAS_CHAR: .asciiz "Número de telefone inválido."
	STATUS_NONE: 		.asciiz "none\n"
	name: 				.space 48
	phonenumber: 		.space 16
	email: 				.space 48
	lineToWrite: 		.space 200
.text 
	.globl newClient
newClient:
	li 		$v0, 4
	la 		$a0, PROMPT_NAME
	syscall
	
	li 		$v0, 8
	la 		$a0, name
	li 		$a1, 48
	syscall
	# format name
	la 		$s0, name 
loop_formatName:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, getUserPhone
	beq 	$s1, 32, spaceToUnderscore
	blt 	$s1, 97, upperToLower
	addi 	$s0, $s0, 1
	j 		loop_formatName
upperToLower:
	addi 	$s1, $s1, 32
	sb 		$s1, 0($s0)
	addi 	$s0, $s0, 1
	j 		loop_formatName
spaceToUnderscore:
	li 		$s2, 95
	sb 		$s2, 0($s0) 
	addi 	$s0, $s0, 1
	j 		loop_formatName
getUserPhone:
	sb 		$zero, 0($s0)
	li 		$v0, 4
	la 		$a0, PROMPT_PHONENUMBER
	syscall
	
	li 		$v0, 8
	la 		$a0, phonenumber
	li 		$a1, 16
	syscall
	
	# check for chars
	la 		$s0, phonenumber
loop_checkForChar:
	lb 		$s1, 0($s0)
	beq		$s1, 10, getUserEmail
	blt 	$s1, 48, charFound
	bgt 	$s1, 57, charFound
	addi 	$s0, $s0, 1
	j 		loop_checkForChar
charFound:
	la 		$s0, MSG_PHONE_HAS_CHAR
	la 		$s1, message
loop_charFound:
	lb 		$s2, 0($s0)
	beqz 	$s2, endloop_charFound
	sb 		$s2, 0($s1)
	addi 	$s0, $s0, 1
	addi	$s1, $s1, 1
	j 		loop_charFound
endloop_charFound:
	sb 		$s2, 1($s1)
	
	jr 		$ra
getUserEmail:
	sb 		$zero, 0($s0)
	li		$v0, 4
	la 		$a0, PROMPT_EMAIL
	syscall
	
	li 		$v0, 8
	la 		$a0, email
	li 		$a1, 48
	syscall
	
printNameToLineBuffer:
	la 		$s0, lineToWrite
	la 		$s1, name
loop_printNameToLineBuffer:
	lb 		$s3, 0($s1)
	beqz 	$s3, printPhoneToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printNameToLineBuffer
printPhoneToLineBuffer:
	li 		$s4, 44
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, phonenumber
loop_printPhoneToLineBuffer:
	lb 		$s3, 0($s1)
	beqz 	$s3, printEmailToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printPhoneToLineBuffer
printEmailToLineBuffer:
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, email
loop_printEmailToLineBuffer:
	lb 		$s3, 0($s1)
	beq 	$s3, 10, printStatusToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printEmailToLineBuffer
printStatusToLineBuffer:
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la		$s1, STATUS_NONE
loop_printStatusToLineBuffer:
	lb 		$s3, 0($s1)
	beqz	$s3, writeToFile
	sb		$s3, 0($s0)
	addi	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j		loop_printStatusToLineBuffer
writeToFile:
	addi 	$s0, $s0, 1
	sb 		$zero, 0($s0)
	li 		$v0, 13
	la 		$a0, CLIENTS_FILE_NAME
	li 		$a1, 9
	li 		$a2, 0
	syscall

	la 		$s7, lineToWrite
	li 		$s6, 0
findStringLenght:
	lb 		$s5, 0($s7)
	beqz 	$s5, doneLenght
	addi 	$s7, $s7, 1
	addi 	$s6, $s6, 1
	j 		findStringLenght
doneLenght:
	move 	$s0, $v0
	li 		$v0, 15
	move 	$a0, $s0
	la 		$a1, lineToWrite
	move 	$a2, $s6
	syscall
	
	li 		$v0, 16
	move 	$a0, $s0
	syscall
	
	la 		$s0, MSG_CLIENT_ADDED
	la 		$s1, message
loop_clientAdded:
	lb 		$s2, 0($s0)
	beqz 	$s2, endloop_clientAdded
	sb 		$s2, 0($s1)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_charFound
endloop_clientAdded:
	sb 		$s2, 1($s1)
	
	jr 		$ra
