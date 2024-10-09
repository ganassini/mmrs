# System calls:
# --------------------------
# | FUNCTION      | OPCODE |
# --------------------------
# | exit		  |   10   |
# --------------------------
.data
.text
main:
	# display menu
	jal displayMenu
	# exit program
	li $v0, 10
	syscall
	
