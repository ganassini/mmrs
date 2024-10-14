.data
	STRING_MENU: 		.asciiz "*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\n*  locadora de filme kkkk   *\n*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\n1. Registrar locação\n2. Registrar devolução\n3. Adicionar filme\n4. Buscar filme\n5. Listar filmes\n6. Novo cliente\n7. Listar clientes\n8. Sair\n\n"
	STRING_PROMPT: 		.asciiz "\n\n>> "
	STRING_PROMPT_N: 	.asciiz ">> "
	MSG_INVALID_OPTION: .asciiz "Opção inválida."
	message: 			.space  48
.text
	.globl message
main:
	li		$v0, 4 
	la 		$a0, STRING_MENU
	syscall
	
	lb 		$t0, message
	bnez 	$t0, messageExists
	la 		$a0, STRING_PROMPT_N
	syscall
	
	j 		getUserOption
messageExists:
	la 		$a0, message
	syscall 
	
	la 		$a0, STRING_PROMPT
	syscall
	
	j 		getUserOption
getUserOption:
	li 		$v0, 5
	syscall
	
	beq 	$v0, 1, callRegisterRental
	beq 	$v0, 2, callRegisterDevolution
	beq 	$v0, 3,	callAppendMovie
	beq 	$v0, 4, callFindMovie
	beq 	$v0, 5, callListMovies
	beq 	$v0, 6, callNewClient
	beq 	$v0, 7, listClients
	beq 	$v0, 8, exitProgram
	j 		invalidOption
callRegisterRental:
	jal 	registerRental
	j 		main
callRegisterDevolution:
	jal		registerDevolution
	j 		main
callAppendMovie:
	jal 	appendMovie
	j 		main
callFindMovie:
	jal 	findMovie
	j 		main
callListMovies:
	jal 	listMovies
	j 		main
callNewClient:
	jal 	newClient
	j 		main
callListClients:
	jal 	listClients
	j 		main
invalidOption:
	la 		$t1, MSG_INVALID_OPTION
	la 		$t2, message
exitProgram:
	li 		$v0, 10
	syscall
