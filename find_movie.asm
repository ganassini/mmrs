.data
	MOVIES_FILE_NAME: .asciiz "mmrs/movies.txt"        
	PROMPT_MOVIE_TITLE: .asciiz "Título do filme: "
	MSG_MOVIE_NOT_FOUND: .asciiz "Filme não encontrado.\n"
	movieToSearch: .space 48 
	buffer: .space 256      
	underscore: .asciiz "_"
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

    beqz 	$v0, check_results               

    la 		$t0, buffer                        
    li 		$t5, 0                             

process_buffer:
    lb 		$t1, 0($t0)                        
    beqz 	$t1, compare_strings             

    li 		$t2, 'A'                           
    li 		$t3, 'Z'                           
    li 		$t4, 'a'                           
    blt 	$t1, $t2, check_space             
    bgt 	$t1, $t3, check_space             

    addi	$t1, $t1, 32                     
    sb 		$t1, 0($t0)                       
    
    j compare_strings

check_space:
    li 		$t6, ' '                           
    beq 	$t1, $t6, replace_space           

    addi 	$t0, $t0, 1                      
    j process_buffer                      

replace_space:
    lb 		$t1, underscore                    
    sb 		$t1, 0($t0)                       

    addi 	$t0, $t0, 1                      
    j process_buffer                      

compare_strings:
    la 		$t0, buffer                        
    la 		$t1, search_name                   

    la 		$t2, search_name                   
    li 		$t3, 0                             

process_search_name:
    lb 		$t4, 0($t2)                        
    beqz 	$t4, read_file                  

    li 		$t5, 'A'                           
    li 		$t6, 'Z'                           
    li 		$t7, 'a'                           
    blt 	$t4, $t5, check_search_space      
    bgt 	$t4, $t6, check_search_space      

    addi 	$t4, $t4, 32                     
    sb 		$t4, 0($t2)                       
    
    j compare_loop

check_search_space:
    li 		$t8, ' '                           
    beq 	$t4, $t8, replace_search_space     

    addi 	$t2, $t2, 1                      
    j process_search_name                 

replace_search_space:
    lb 		$t4, underscore                    
    sb	 	$t4, 0($t2)                       

    addi 	$t2, $t2, 1                      
    j process_search_name                 

	la 		$t0, buffer                        
	la 		$t1, search_name                   

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
    li 		$v0, 4                             
    la 		$a0, buffer                        
    syscall

    li 		$t6, 1                             
    j read_file                           

check_results:
    beqz 	$t6, not_found_msg               

    j close_file                         

not_found_msg:
    li 		$v0, 4                             
    la 		$a0, not_found                    
    syscall

close_file:
    li 		$v0, 16                            
    move 	$a0, $s0                         
    syscall

exit:
    li 		$v0, 10                            
    syscall