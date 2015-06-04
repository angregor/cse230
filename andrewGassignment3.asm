.data
num1: .word 11
num2: .word 2
text1: .asciiz "\nremainder "
text2: .asciiz "\ndivision "
name: .asciiz "\n..."
newLine: .asciiz "\n"
prompt: .asciiz "Please enter an integer: "
.text
.globl main

main:
	
	lui $a0, 0x1001		# get start of data
	addiu $a0, $a0, 0x001f	# get start of name
	andi $a2, $0, 0		# set flag to false
	jal print		# print name

	lui $a0, 0x1001		# set address of first word
	addiu $a1, $a0, 4	# set address of second word
	jal getinput		# call function to get input, store into memory
		
	lui $t0, 0x1001		# get address of first word
	lw $a0, 0($t0)		# get the first value from memory
	lw $a1, 4($t0)		# get the second value from memory
	jal divide		# divide the values, result in $v0
	addi $a1, $v0, 0	# get value to print from $v0
	lui $a0, 0x1001		# get start of data section
	addi $a0, $a0, 0x14	# get start of divide output string
	ori $a2, $0, 1		# set flag to true
	jal print		# print result
	
	lui $t0, 0x1001		# get address of first word
	lw $a0, 0($t0)		# get first value from memory
	lw $a1, 4($t0)		# get second value from memory
	jal mod			# divide the values, remainder in $v0
	addi $a1, $v0, 0	# get value to print from $v0
	lui $a0, 0x1001		# get start of data section
	addi $a0, $a0, 8	# get start of remainder output string
	ori $a2, $0, 1		# set flag to true
	jal print		# print result
	
	ori $v0, $0, 10		# set command to stop program,
	syscall			

print:
	#allocate memory
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#setup
	addi $t7, $zero, 1
	#print
	addi $v0, $zero, 4
	syscall
	#new line
	lui $a0, 0x1001
	addi $a0, $a0, 36
	syscall
	#check condition
	beq $t7, $a2, both
	#deallocate
	lw $ra 0($sp)
	addi $sp, $sp, 4
	#return to $ra
	jr $ra
	both: 	addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall
		#deallocate
		lw $ra 0($sp)
		addi $sp, $sp, 4
		#return to $ra
		jr $ra
		
divide:
	#setup for integer division
	add $t1, $zero, $a0
	addi $t3, $zero, 1
	add $v0, $zero, $zero
	#loop for division
	topDiv: 	
		beq $t1, $zero, endZeroDiv
		addi $v0, $v0, 1
		sub $t1, $t1, $a1
		slti $t2, $t1, 0
		beq $t2, $t3, endRemainDiv 
		j topDiv
	#end of division with no remainder
	endZeroDiv: 	jr $ra
	#end of division with remainder
	endRemainDiv:	sub $v0, $v0, $t3
			jr $ra
	
mod: 	
	#setup for modulo
	add $t1, $zero, $a0
	addi $t3, $zero, 1
	#loop for modulo
	topMod: 	
		sub $t1, $t1, $a1
		beq $t1, $zero, endZeroMod
		slti $t2, $t1, 0
		beq $t2, $t3, endRemainMod 
		j topMod
	#end of modulo with no remainder
	endZeroMod: 	addi $v0, $zero, 0
			jr $ra
	#end of modulo with remainder
	endRemainMod: 	add $v0, $t1, $a1
			jr $ra
			
getpos:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	#loop until input is not 0
	loopPos:
		lui $a0, 0x1001
		addi $a0, $a0, 38
		addi $a2, $zero, 0
		jal print
		addi $v0, $zero, 5
		syscall
		bne $v0, $zero, endPos
		j loopPos
	endPos:
	#restore registers and deallocate stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
getinput:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#call getpos
	jal getpos
	sw $v0, 0($a0)
	jal getpos
	sw $v0, 0($a1)
	#restore and deallocate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra