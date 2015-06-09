#Andrew Gregory
#CSE 230 M-F 10:10AM - 11:10AM
#Assignment 3
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
	
	ori $v0, $0, 10		#set command to stop program
	syscall			#stop program

print:
	#allocate memory
	addi $sp, $sp, -4			#pushes the stack pointer back 4
	sw $ra, 0($sp)				#stores the return address in the location of the stack pointer
	#setup
	addi $t7, $zero, 1			#sets $t7 to 1
	#print
	addi $v0, $zero, 4			#puts the command to print into $v0
	syscall					#prints the value in $a0
	#new line
	lui $a0, 0x1001				#loads upper portion of $a0 with 0x1001
	addi $a0, $a0, 36			#adds 36 to the current value of $a0
	syscall					#prints the value in $a0
	#check condition
	beq $t7, $a2, both			#checks if $a2 is equal to $t7, and branches to both if it is
	#deallocate
	lw $ra 0($sp)				#restores the return address
	addi $sp, $sp, 4			#restores the stack pointers
	jr $ra					#return to $ra
	both: 	
		addi $v0, $zero, 1		#sets $v0 to the value to print an int
		addi $a0, $a1, 0		#puts the value in $a1 into $a0
		syscall				#prints the int in $a0
		#deallocate
		lw $ra 0($sp)			#restores return address
		addi $sp, $sp, 4		#restores stack pointer
		jr $ra				#return to $ra
		
divide:
	#setup for integer division
	add $t1, $zero, $a0			#sets $t1 to $a0
	addi $t3, $zero, 1			#sets $t3 to 1
	add $v0, $zero, $zero			#sets $v0 to 0
	#loop for division
	topDiv: 	
		beq $t1, $zero, endZeroDiv	#checks if $t1 equals zero, if so jumps to endZeroDiv
		addi $v0, $v0, 1		#adds 1 to $v0
		sub $t1, $t1, $a1		#subtracts $a1 from $t1 and stores the answer in $t1
		slti $t2, $t1, 0		#checks if $t1 is less than 0 and stores answer in $t2
		beq $t2, $t3, endRemainDiv 	#chekcs if $t2 is equal to $t3 if so jumps to endRemainDiv
		j topDiv			#jumps to topDiv
	#end of division with no remainder
	endZeroDiv: 	jr $ra			#returns to previous address
	#end of division with remainder
	endRemainDiv:	sub $v0, $v0, $t3	#sets $v0 to the value of $v0 - $t3
			jr $ra			#returns to previous address
	
mod: 	
	#setup for modulo
	add $t1, $zero, $a0			#sets $t1 to the value of the first argument
	addi $t3, $zero, 1			#sets $t3 to 1
	#loop for modulo			
	topMod: 				
		sub $t1, $t1, $a1		#subtracts $a1 from $t1
		beq $t1, $zero, endZeroMod	#checks if $t1 is zero, if so it branches to endZeroMod
		slti $t2, $t1, 0		#checks if $t1 is smaller than 0, and stores the answer in $t2
		beq $t2, $t3, endRemainMod 	#checks if $t2 and $t3 are equal, if so jumps to endRemainMod
		j topMod			#jumps to topMod
	#end of modulo with no remainder
	endZeroMod: 	addi $v0, $zero, 0	#adds the value of zero to be returned
			jr $ra			#returns to previous address
	#end of modulo with remainder
	endRemainMod: 	add $v0, $t1, $a1	#puts the value into $v0 to be returned
			jr $ra			#returns to previous address
			
getpos:
	addi $sp, $sp, -12			#pushes the stack pointer back 12
	sw $ra, 0($sp)				#saves the return address in the location of the stack pointer
	sw $a0, 4($sp)				#saves $a0 in the location 4 displacement from the stack pointer
	sw $a1, 8($sp)				#saves $a1 in the location 8 displacement from the stack pointer
	#loop until input is not 0
	loopPos:
		lui $a0, 0x1001			#loads $a0 with the value 0x10010000
		addi $a0, $a0, 38		#adds 38 to $a0 giving the value 0x10010038
		addi $a2, $zero, 0		#sets $a2 to 0
		jal print			#jumps to the print function
		addi $v0, $zero, 5		#puts the command to take integer input into $v0
		syscall				#takes integer input
		bne $v0, $zero, endPos		#checks to see if input was 0, if it was, repeat loop
		j loopPos			#jumps to top of loop
	endPos:
	#restore registers and deallocate stack
	lw $ra, 0($sp)				#restores $ra
	lw $a0, 4($sp)				#restores $a0
	lw $a1, 8($sp)				#restores $a1
	addi $sp, $sp, 12			#restores stack pointer
	jr $ra					#returns to return address
	
getinput:
	addi $sp, $sp, -4			#moves the stack pointer back 4
	sw $ra, 0($sp)				#stores the return address at 0 displacement from current stack pointer
	#call getpos
	jal getpos				#jumps to getpos, stores ra in register
	sw $v0, 0($a0)				#stores the returned value intro the value 0 displacement from $a0
	jal getpos				#jumps to getpos, stores ra in register
	sw $v0, 0($a1)				#stores the returned value intro the value 0 displacement from $a1
	#restore and deallocate
	lw $ra, 0($sp)				#loads the return address that was previously stored
	addi $sp, $sp, 4			#restores the stack pointer to its original location
	jr $ra					#jumps to return address
