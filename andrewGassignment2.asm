#Andrew Gregory Assignment #2
#Class: CSE 230: M-F 10:10AM - 11:10AM
#Date: TBA
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
addi $v0, $zero, 4
addi $a0, $s0, 46
syscall

#new line
addi $v0, $zero, 4
addi $a0, $s0, 46
syscall

#prompt 1
addi $v0, $zero, 4
addi $a0, $s0, 23
syscall

#get input 1
addi $v0, $zero, 5
syscall
addi $s1, $v0, 0

#prompt 2
addi $v0, $zero, 4
addi $a0, $s0, 23
syscall

#get input 2
addi $v0, $zero, 5
syscall
addi $s2, $v0, 0

#Step 3
addi $t1, $s1, 0
addi $t2, $s2, 0
slt $t3, $t1, $t2
addi $t1, $t1, -1
bne $t3, $zero, startUp
addi $t1, $t1, 2
startDown: addi $t1, $t1, -1
	beq $t1, $t2, end
	
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	
	#space
	addi $v0, $zero, 4
	addi $a0, $s0, 48
	syscall

	j startDown

startUp: addi $t1, $t1, 1
	beq $t1, $t2, end
	
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	
	#space
	addi $v0, $zero, 4
	addi $a0, $s0, 48
	syscall

	j startUp

end: 	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
#Step 4 (program complete message)

#new line
addi $v0, $zero, 4
addi $a0, $s0, 46
syscall
syscall

#complete message
addi $v0, $zero, 4
addi $a0, $s0, 50
syscall