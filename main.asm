.data
	STRING_MENU: .asciiz "*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\n*  locadora de filme kkkk   *\n*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\n1. Registrar locação\n2. Adicionar filme\n3. Buscar filme\n4. Listar filmes\n5. Novo cliente\n6. Sair\n\n"
	STRING_PROMPT: .asciiz "\n\n>> "
	STRING_PROMPT_N: .asciiz ">> "
	message: .space  48
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
	
	j getUserOption
messageExists:
	la 		$a0, message
	syscall 
	
	la 		$a0, STRING_PROMPT
	syscall
	
	j getUserOption
getUserOption:
	li 		$v0, 5
	syscall
	
	beq 	$v0, 1, callRegisterRental
	beq 	$v0, 2,	callAppendMovie
	beq 	$v0, 3, callFindMovie
	beq 	$v0, 4, callListMovies
	beq 	$v0, 5, callNewClient
	beq 	$v0, 6, exitProgram
callRegisterRental:
	jal registerRental
	j main
callAppendMovie:
	jal appendMovie
	j main
callFindMovie:
	jal findMovie
	j main
callListMovies:
	jal findMovie
	j main
callNewClient:
	jal newClient
	j main
exitProgram:
	li 		$v0, 10
	syscall
