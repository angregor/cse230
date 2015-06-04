#Andrew Gregory Assignment #2
#Class: CSE 230: M-F 10:10AM - 11:10AM
#Date: 6/1/2015
.data 
input1: .word 1
input2: .word 2
name: .asciiz "Andrew Gregory"
prompt: .asciiz "Please enter a number "
nl: .asciiz "\n"
space: .asciiz " "
endMessage: .asciiz "Program complete"
.globl main 
.text 
main:
#Step 1 (print name)

addi $v0, $zero, 4			#load instruction to print string into $v0
lui $s0, 0x1001				#load upper immediate of $s0 with 0x1001
addi $a0, $s0, 8			#adds 8 to $s0 to store 0x1001008 into $a0
syscall					#prints the string found at 0x1001008

#Step 2 (prompt and read two integers)

#new line
addi $v0, $zero, 4			#loads the command to print a string into $v0
addi $a0, $s0, 46			#loads the ascii string which starts at 0x1001002E into $a0
syscall					#prints the string

#new line
addi $v0, $zero, 4			#loads the command to print a string into $v0
addi $a0, $s0, 46			#loads the ascii string which starts at 0x1001002E into $a0
syscall					#prints the string

#prompt 1
addi $v0, $zero, 4			#loads the command to print a string into $v0			
addi $a0, $s0, 23			#loads the ascii string which starts at 0x10010017 into $a0
syscall					#prints the string

#get input 1
addi $v0, $zero, 5			#loads the command to get an integer into $v0
syscall					#the console waits for an input
addi $s1, $v0, 0			#stores that input into $s1

#prompt 2
addi $v0, $zero, 4			#loads the command to print a string into $v0
addi $a0, $s0, 23			#loads the ascii string which starts at 0x10010017 into $a0
syscall					#prints the string

#get input 2
addi $v0, $zero, 5			#loads the command to get an integer into $v0
syscall					#the console waits for an input
addi $s2, $v0, 0			#stores that input into $s2

#Step 3
addi $t1, $s1, 0			#puts the first number into the temp $t1
addi $t2, $s2, 0			#puts the second number into the temp $t2
slt $t3, $t1, $t2			#checks if the first number is smaller than the second
addi $t1, $t1, -1			#subtract 1 from the first number to prep for startUp
bne $t3, $zero, startUp			#if the first number is smaller $t3 = 1, therefore branch to startUp
addi $t1, $t1, 2 			#startDown has the first number begin at 1 higher than the input
#if first number is greater than second
startDown: addi $t1, $t1, -1		#subtracts 1 from the value in $t1
	beq $t1, $t2, end		#if the values are equal branch to end label
	
	#print current value of $t1
	addi $v0, $zero, 1		#puts the command to print an integer into $v0
	addi $a0, $t1, 0		#puts the value of $t1 into $a0
	syscall				#prints $t1
	
	#space
	addi $v0, $zero, 4		#loads the command to print a string into $v0
	addi $a0, $s0, 48		#loads the ascii string stored at 0x10010030 into $a0
	syscall				#prints the string

	j startDown			#jumps to top of loop

#if first number is smaller than second number
startUp: addi $t1, $t1, 1		#adds 1 to the value of $t1
	beq $t1, $t2, end		#if they are equal branch to the end label
	
	#print current value of $t1
	addi $v0, $zero, 1		#loads the command to print an integer into $v0
	addi $a0, $t1, 0		#adds the value in $t1 into $a0
	syscall				#prints $t1
	
	#space
	addi $v0, $zero, 4		#loads the command to print a string into $v0
	addi $a0, $s0, 48		#loads the ascii string stored at 0x10010030 into $a0
	syscall				#prints the string	

	#loop to label startUp
	j startUp			#jumps to top of loop

end: 	addi $v0, $zero, 1		#puts the command to print an integer into $v0
	addi $a0, $t1, 0		#puts the value in $t1 into $a0
	syscall				#prints $t1

#Step 4 (program complete message)

#new line
addi $v0, $zero, 4			#loads the command to print a string into $v0
addi $a0, $s0, 46			#loads the ascii string which starts at 0x1001002E into $a0
syscall					#prints the string
syscall					#prints the string again

#complete message
addi $v0, $zero, 4			#loads the command to print a string into $v0
addi $a0, $s0, 50			#loads the ascii string which starts at 0x10010032 into $a0
syscall					#prints the string

#end program
addi $v0, $zero, 10			#loads the command to end the program into $v0
syscall					#ends the program
