.data
	MOVIES_FILE_NAME: 			.asciiz "mmrs/movies.txt"
	PROMPT_TITLE: 				.asciiz "Titulo: "
	PROMPT_RELEASE_YEAR: 		.asciiz "Ano de lançamento: "
	PROMPT_DURATION: 			.asciiz "Duração: "
	PROMPT_DIRECTOR: 			.asciiz "Diretor: "
	PROMPT_IMDB_RATING: 		.asciiz "Nota IMDB: "
	STATUS_AVAILABLE: 			.asciiz "disponivel\n"
	MSG_RELEASE_YEAR_HAS_CHAR: 	.asciiz "Ano de lançamento inválido."
	MSG_MOVIE_ADDED: 			.asciiz "Filme adicionado com sucesso."
	title: 			.space 48
	releaseYear: 	.space 6
	duration: 		.space 10
	director: 		.space 48
	imdbRating: 	.space 6
	lineToWrite: 	.space 200
.text 
	.globl appendMovie
appendMovie:
getMovieTitle:
	li 		$v0, 4
	la 		$a0, PROMPT_TITLE
	syscall
	
	li 		$v0, 8
	la 		$a0, title
	li 		$a1, 48
	syscall
	# format title
	la 		$s0, title 
loop_formatName:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, getMovieReleaseYear
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
getMovieReleaseYear:
	sb 		$zero, 0($s0)
	li 		$v0, 4
	la 		$a0, PROMPT_RELEASE_YEAR
	syscall
	
	li 		$v0, 8
	la 		$a0, releaseYear
	li 		$a1, 6
	syscall
	
	# check for chars
	la 		$s0, releaseYear
loop_checkForChar:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, getMovieDuration
	blt 	$s1, 48, charFound
	bgt 	$s1, 57, charFound
	addi 	$s0, $s0, 1
	j 		loop_checkForChar
charFound:
	la 		$s0, MSG_RELEASE_YEAR_HAS_CHAR
	la 		$s1, message
	j 		endloop_charFound
loop_charFound:
	lb 		$s2, 0($s0)
	beqz 	$s2, getMovieDuration
	sb 		$s2, 0($s1)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_charFound
endloop_charFound:
	sb 		$s2, 1($s1)
	
	jr 		$ra
getMovieDuration:
	li 		$v0, 4
	la 		$a0, PROMPT_DURATION
	syscall
	
	li 		$v0, 8
	la 		$a0, duration
	li		$a1, 10
	syscall
getMovieDirector:
	li 		$v0, 4
	la 		$a0, PROMPT_DIRECTOR
	syscall
	
	li 		$v0, 8
	la 		$a0, director
	li 		$a1, 48
	syscall
	# format name
	la 		$s0, director 
loop_formatDirectorName:
	lb 		$s1, 0($s0)
	beq 	$s1, 10, getMovieImdbRating
	beq 	$s1, 32, spaceToUnderscoreDirector
	blt 	$s1, 97, upperToLowerDirector
	addi 	$s0, $s0, 1
	j 		loop_formatDirectorName
upperToLowerDirector:
	addi 	$s1, $s1, 32
	sb 		$s1, 0($s0)
	addi 	$s0, $s0, 1
	j 		loop_formatDirectorName
spaceToUnderscoreDirector:
	li 		$s2, 95
	sb 		$s2, 0($s0) 
	addi 	$s0, $s0, 1
	j 		loop_formatDirectorName
getMovieImdbRating:
	li 		$v0, 4
	la 		$a0, PROMPT_IMDB_RATING
	syscall
	
	li 		$v0, 8
	la 		$a0, imdbRating
	li 		$a1, 6
	syscall
printTitleToLineBuffer:
	la 		$s0, lineToWrite
	la 		$s1, title
loop_printTitleToLineBuffer:
	lb 		$s3, 0($s1)
	beqz 	$s3, printReleaseYearToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printTitleToLineBuffer
printReleaseYearToLineBuffer:
	li 		$s4, 44
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, releaseYear
loop_printReleaseYearToLineBuffer:
	lb 		$s3, 0($s1)
	beq 	$s3, 10, printDurationToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printReleaseYearToLineBuffer
printDurationToLineBuffer:
	li 		$s4, 44
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, duration
loop_printDurationToLineBuffer:
	lb 		$s3, 0($s1)
	beq 	$s3, 10, printDirectorToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printDurationToLineBuffer
printDirectorToLineBuffer:
	li 		$s4, 44
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, director
loop_printDirectorToLineBuffer:
	lb 		$s3, 0($s1)
	beq 	$s3, 10, printImdbRatingToLineBuffer
	sb 		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_printDirectorToLineBuffer
printImdbRatingToLineBuffer:
	li 		$s4, 44
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, imdbRating
loop_printImdbRatingToLineBuffer:
	lb 		$s3, 0($s1)
	beq 	$s3, 10, printStatusToLineBuffer
	sb 		$s3, 0($s0)
	addi	$s0, $s0, 1
	addi	$s1, $s1, 1
	j 		loop_printImdbRatingToLineBuffer
printStatusToLineBuffer:
	li 		$s4, 44
	sb 		$s4, 0($s0)
	addi 	$s0, $s0, 1
	la 		$s1, STATUS_AVAILABLE
loop_printStatusToLineBuffer:
	lb 		$s3, 0($s1)
	beqz	$s3, writeToFile
	sb		$s3, 0($s0)
	addi 	$s0, $s0, 1
	addi	$s1, $s1, 1
	j		loop_printStatusToLineBuffer
writeToFile:
	addi 	$s0, $s0, 1
	sb 		$zero, 0($s0)
	li 		$v0, 13
	la 		$a0, MOVIES_FILE_NAME
	li 		$a1, 9
	li 		$a2, 0
	syscall

	la 		$s7, lineToWrite
	li 		$s6, 0
findStringLenght:
	lb 		$s5, 0($s7)
	beqz 	$s5, doneLenght
	addi 	$s7, $s7, 1
	addi	$s6, $s6, 1
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
	
	la 		$s0, MSG_MOVIE_ADDED
	la 		$s1, message
loop_movieAdded:
	lb 		$s2, 0($s0)
	beqz 	$s2, endloop_movieAdded
	sb 		$s2, 0($s1)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j 		loop_movieAdded
endloop_movieAdded:
	sb 		$s2, 1($s1)
	
	jr 		$ra
