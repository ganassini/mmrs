.data
	MOVIES_FILE_NAME: .asciiz "movies.txt"        
	PROMPT_MOVIE_TITLE: .asciiz "Título do filme: "
	MSG_MOVIE_NOT_FOUND: .asciiz "Filme não encontrado.\n"
	movieToSearch: .space 48 
	buffer: .space 256      
	newline: .asciiz "\n"                                                 
.text
	.globl findMovie
findMovie: 
    li 		$v0, 4                             
    la 		$a0, PROMPT_MOVIE_TITLE 
    syscall

    li 		$v0, 8                             
    la 		$a0, movieToSearch                  
    li 		$a1, 48                           
    syscall

    li 		$v0, 13                            
    la 		$a0, MOVIES_FILE_NAME                      
    li 		$a1, 0                             
    li 		$a2, 0                             
    syscall

    move 	$s0, $v0                        

    bltz 	$s0, exit                       

    li 		$t6, 0                            

read_file:
    li 		$v0, 14                            
    move 	$a0, $s0                         
    la 		$a1, buffer                        
    li 		$a2, 256                           
    syscall
    
    add     $t0, $a1, $v0
	sb      $zero, 0($t0)

    beqz 	$v0, check_results               

    la 		$t0, buffer                        
    li 		$t5, 0                             

process_buffer:
    lb 		$t1, 0($t0)
    
	beq 	$t1, 32, spaceToUnderscore
	blt 	$t1, 97, upperToLower
	addi 	$t0, $t0, 1
	
	j 		compare_strings                       

upperToLower:
	addi 	$t1, $t1, 32
	sb 		$t1, 0($t0)
	addi 	$t0, $t0, 1
	j 		process_buffer
spaceToUnderscore:
	li 		$t2, 95
	sb 		$t2, 0($t0) 
	addi 	$t0, $t0, 1
	j 		process_buffer                     

compare_strings:
    la 		$t0, buffer                        
    la 		$t1, movieToSearch                   

    la 		$t2, movieToSearch                   
    li 		$t3, 0                             

process_search_name:
    lb 		$t4, 0($t2)
    
	beq 	$t4, 32, process_spaceToUnderscore
	blt 	$t4, 97, process_upperToLower
	addi 	$t2, $t2, 1                       
    
    j compare_loop

process_upperToLower:
	addi 	$t4, $t4, 32
	sb 		$t4, 0($t2)
	addi 	$t2, $t2, 1
	j 		process_search_name
process_spaceToUnderscore:
	li 		$t5, 95
	sb 		$t5, 0($t4) 
	addi 	$t4, $t4, 1
	j 		process_search_name                   

compare_loop:
    lb 		$t2, 0($t0)                        
    lb 		$t3, 0($t1)                       

    beqz 	$t2, check_end                   
    beqz 	$t3, return_not_equal           

    bne 	$t2, $t3, return_not_equal       

    addi 	$t0, $t0, 1                      
    addi 	$t1, $t1, 1                      
    j compare_loop                       

check_end:
    beqz 	$t3, found   

return_not_equal:
    j read_file                           

found:
    li      $v0, 4            
    la      $a0, buffer
    syscall

    j close_file            

check_results:
    beqz    $t6, not_found_msg 
    j close_file             
                         
not_found_msg:
    li 		$v0, 4                             
    la 		$a0, MSG_MOVIE_NOT_FOUND                    
    syscall

close_file:
    li 		$v0, 16                            
    move 	$a0, $s0                         
    syscall

exit:
    li 		$v0, 10                            
    syscall
