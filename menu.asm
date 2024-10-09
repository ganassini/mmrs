# System calls:
# --------------------------
# | FUNCTION      | OPCODE |
# --------------------------
# | print string  |	   4   |
# --------------------------
# | read integer  |	   5   |
# --------------------------
# | exit		  |   10   |
# --------------------------
.data
	STRING_MENU: .asciiz "*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\n*  locadora de filme kkkk   *\n*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\n1. Registrar locação\n2. Adicionar filme\n3. Remover filme\n4. Buscar filme\n5. Listar filmes\n6. Novo cliente\n7. Sair\n\n"
	STRING_PROMPT: .asciiz "\n\n>> "
	STRING_PROMPT_N: .asciiz ">> "
	message: .space  48
.text
	.globl displayMenu
	.globl message
displayMenu:
	# print the menu
	li $v0, 4 
	la $a0, STRING_MENU
	syscall
	# chek if it there is a message to display
	lb $t0, message
	bnez $t0, messageExists
	# print user input prompt
	la $a0, STRING_PROMPT_N
	syscall
	# get user option	
	j getUserOption
messageExists:
	# print the message
	la $a0, message
	syscall 
	# print user input prompt
	la $a0, STRING_PROMPT
	syscall
	# get user option
	j getUserOption
getUserOption:
	li $v0, 5
	syscall
	# 1 - register rental
	# 2 - append movie
	beq $v0, 2, appendMovie
	# 3 - remove movie
	# 4 - find movie
	# 5 - list movies
	# 6 - new client
	beq $v0, 6, newClient
	jal newClient
	j displayMenu
	# 7 - exit program
	beq $v0, 7, exit
	# return
	j exit
exit:
	li $v0, 10
	syscall
