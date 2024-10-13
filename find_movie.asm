.data
	MOVIES_FILE_NAME: 		.asciiz "mmrs/movies.txt"        
	PROMPT_MOVIE_TITLE: 	.asciiz "Título do filme: "
	MSG_MOVIE_NOT_FOUND: 	.asciiz "Filme não encontrado.\n"
	UNDERSCORE: 			.asciiz "_"
	NEWLINE: 				.asciiz "\n" 
	movieToSearch: 	.space 48 
	buffer: 		.space 256                                                      
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
    li 		$t6, 0                            
readFile:
    li 		$v0, 14                            
    move 	$a0, $s0                         
    la 		$a1, buffer                        
    li 		$a2, 256                           
    syscall

    beqz 	$v0, checkResults               
    la 		$t0, buffer                        
    li 		$t5, 0                             
processBuffer:
    lb 		$t1, 0($t0)                        
    beqz 	$t1, compareStrings             
    li 		$t2, 'A'                           
    li 		$t3, 'Z'                           
    li 		$t4, 'a'                           
    blt 	$t1, $t2, checkSpace             
    bgt 	$t1, $t3, checkSpace            
    addi	$t1, $t1, 32                     
    sb 		$t1, 0($t0)                       
    j 		compareStrings
checkSpace:
    li 		$t6, ' '                           
    beq 	$t1, $t6, replaceSpace           
    addi 	$t0, $t0, 1                      
    j 		processBuffer                      
replaceSpace:
    lb 		$t1, UNDERSCORE                    
    sb 		$t1, 0($t0)                       
    addi 	$t0, $t0, 1                      
    j 		processBuffer                      
compareStrings:
    la 		$t0, buffer                        
    la 		$t1, movieToSearch                   
    la 		$t2, movieToSearch                   
    li 		$t3, 0                             
processMovieToSearch:
    lb 		$t4, 0($t2)                        
    beqz 	$t4, readFile                  
    li 		$t5, 'A'                           
    li 		$t6, 'Z'                           
    li 		$t7, 'a'                           
    blt 	$t4, $t5, checkSearchSpace      
    bgt 	$t4, $t6, checkSearchSpace      
    addi 	$t4, $t4, 32                     
    sb 		$t4, 0($t2)                          
    j 		loop_compare
checkSearchSpace:
    li 		$t8, ' '                           
    beq 	$t4, $t8, replaceSearchSpace     
    addi 	$t2, $t2, 1                      
    j 		processMovieToSearch                 
replaceSearchSpace:
    lb 		$t4, UNDERSCORE                    
    sb	 	$t4, 0($t2)                       
    addi 	$t2, $t2, 1                      
    j 		processMovieToSearch                 
	la 		$t0, buffer                        
	la 		$t1, movieToSearch                   
loop_compare:
    lb 		$t2, 0($t0)                        
    lb 		$t3, 0($t1)                       
    beqz 	$t2, checkEnd                   
    beqz 	$t3, returnNotEqual           
    bne 	$t2, $t3, returnNotEqual       
    addi 	$t0, $t0, 1                      
    addi 	$t1, $t1, 1                      
    j 		loop_compare                      
checkEnd:
    beqz 	$t3, found   
returnNotEqual:
    j 		readFile                           
found:
    li 		$v0, 4                             
    la 		$a0, buffer                        
    syscall

    li 		$t6, 1                             
    j 		readFile                           
checkResults:
    beqz 	$t6, notFoundMsg             
    j 		closeFile                         
notFoundMsg:
    li 		$v0, 4                             
    la 		$a0, MSG_MOVIE_NOT_FOUND                   
    syscall
closeFile:
    li 		$v0, 16                            
    move 	$a0, $s0                         
    syscall
exit:
    li 		$v0, 10                            
    syscall
