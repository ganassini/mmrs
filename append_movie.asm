.data
	MOVIES_FILE_NAME: .asciiz "mmrs/movies.txt"
	PROMPT_TITLE: .asciiz "\nTitulo: "
	PROMPT_RELEASE_YEAR: .asciiz "\nAno de lançamento: "
	PROMPT_DURATION: .asciiz "\nDuração: "
	PROMPT_DIRECTOR: .asciiz "\nDiretor: "
	PROMPT_IMDB_RATING: .asciiz "\nNota IMDB: "
	title: .space 48
	releaseYear: .space 6
	duration: .space 10
	director: .space 48
	imdbRating: .space 6
	lineBuffer: .space 200
.text 
	.globl appendMovie
appendMovie:
getMovieTitle:
	li $v0, 4
	la $a0, PROMPT_TITLE
	syscall
	
	li $v0, 8
	la $a0, title
	li $a1, 48
	syscall
	# format name
	la $s0, title 
loop_formatName:
	lb $s1, 0($s0)
	beq $s1, 10, getMovieReleaseYear
	beq $s1, 32, spaceToUnderscore
	blt $s1, 97, upperToLower
	addi $s0, $s0, 1
	j loop_formatName
upperToLower:
	addi $s1, $s1, 32
	sb $s1, 0($s0)
	addi $s0, $s0, 1
	j loop_formatName
spaceToUnderscore:
	li $s2, 95
	sb $s2, 0($s0) 
	addi $s0, $s0, 1
	j loop_formatName
getMovieReleaseYear:
	li $v0, 4
	la $a0, PROMPT_RELEASE_YEAR
	syscall
	
	li $v0, 8
	la $a0, releaseYear
	li $a1, 6
	syscall
getMovieDuration:
	li $v0, 4
	la $a0, PROMPT_DURATION
	syscall
	
	li $v0, 8
	la $a0, duration
	li $a1, 10
	syscall
getMovieDirector:
	li $v0, 4
	la $a0, PROMPT_DIRECTOR
	syscall
	
	li $v0, 8
	la $a0, director
	li $a1, 48
	syscall
	# format name
	la $s0, director 
loop_formatDirectorName:
	lb $s1, 0($s0)
	beq $s1, 10, getMovieImdbRating
	beq $s1, 32, spaceToUnderscoreDirector
	blt $s1, 97, upperToLowerDirector
	addi $s0, $s0, 1
	j loop_formatDirectorName
upperToLowerDirector:
	addi $s1, $s1, 32
	sb $s1, 0($s0)
	addi $s0, $s0, 1
	j loop_formatDirectorName
spaceToUnderscoreDirector:
	li $s2, 95
	sb $s2, 0($s0) 
	addi $s0, $s0, 1
	j loop_formatDirectorName
getMovieImdbRating:
	li $v0, 4
	la $a0, PROMPT_IMDB_RATING
	syscall
	
	li $v0, 8
	la $a0, imdbRating
	li $a1, 48
	syscall
printTitleToLineBuffer:
	la $s0, lineBuffer
	la $s1, title
loop_printTitleToLineBuffer:
	lb $s3, 0($s1)
	beqz $s3, printReleaseYearToLineBuffer
	sb $s3, 0($s0)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j loop_printTitleToLineBuffer
printReleaseYearToLineBuffer:
	li $s4, 44
	sb $s4, 0($s0)
	addi $s0, $s0, 1
	la $s1, releaseYear
loop_printReleaseYearToLineBuffer:
	lb $s3, 0($s1)
	beqz $s3, printDurationToLineBuffer
	sb $s3, 0($s0)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j loop_printReleaseYearToLineBuffer
printDurationToLineBuffer:
	la $s0, lineBuffer
	la $s1, title
loop_printDurationToLineBuffer:
	lb $s3, 0($s1)
	beqz $s3, printDirectorToLineBuffer
	sb $s3, 0($s0)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j loop_printDurationToLineBuffer
printDirectorToLineBuffer:
	la $s0, lineBuffer
	la $s1, title
loop_printDirectorToLineBuffer:
	lb $s3, 0($s1)
	beqz $s3, printImdbRatingToLineBuffer
	sb $s3, 0($s0)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j loop_printDirectorToLineBuffer
printImdbRatingToLineBuffer:
	la $s0, lineBuffer
	la $s1, title
loop_printImdbRatingToLineBuffer:
	lb $s3, 0($s1)
	beqz $s3, writeToFile
	sb $s3, 0($s0)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j loop_printImdbRatingToLineBuffer
writeToFile:
	addi $s0, $s0, 1
	sb $zero, 0($s0)
	li $v0, 13
	la $a0, MOVIES_FILE_NAME
	li $a1, 1
	li $a2, 0
	syscall

	la $s7, lineBuffer
	li $s6, 0
findStringLenght:
	lb $s5, 0($s7)
	beqz $s5, doneLenght
	addi $s7, $s7, 1
	addi $s6, $s6, 1
	j findStringLenght
doneLenght:
	move $s0, $v0
	li $v0, 15
	move $a0, $s0
	la $a1, lineBuffer
	move $a2, $s6
	syscall
	
	li $v0, 16
	move $a0, $s0
	syscall	