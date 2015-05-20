.data 
val1: .word 1 
val2: .word 2 
val3: .word 3			
str1: .asciiz  "Andrew Gregory"	#labels str1 and creates the data of "Andrew Gregory"
str2: .asciiz  "Enter a number"	#labels str2 and creates the data of "Enter a number"
str3: .asciiz  "\n"		#labels str3 and creates the data of "\n"
.globl main 
.text 
main:
#Step 1
addi $s0, $zero, 30  		#sets value of $s0 to 30.
#Step 2
#ask for number
addi $v0, $zero, 4 		#puts the command to print a string into $v0
lui $a0, 0x1001 		#initializes $a0 to start of .data
addi $a0, $a0, 27		#puts the str2 pointer into $a0 to be printed
syscall 			#prints str2 after reading previous 2 lines
#put number in $s1
addi $v0, $zero, 5 		#puts the command to read an integer into $v0
syscall 			#executes command to read a number
addi $s1, $v0, 0 		#puts the read value into register $s1
#Step 3
#ask for number
addi $v0, $zero, 4  		#puts the command to print a string into $v0
lui $a0, 0x1001 		#initializes $a0 to start of .data
addi $a0, $a0, 27		#puts the str2 pointer into $a0 to be printed
syscall 			#prints str2 after reading previous 2 lines
#put number in $s2
addi $v0, $zero, 5 		#puts the command to read an integer into $v0
syscall 			#executes command to read a number
addi $s2, $v0, 0		#puts the read value into register $s2
#Step 4
lui $t0, 0x1001			#sets t0 as the base register
sw $s1, 0($t0)			#stores $s1 in 0x10010000 (0 displacement from $t0)
#Step 5
sw $s2, 4($t0)			#stores $s2 in 0x10010004 (4 displacement from $t0)
#Step 6
sub $t1, $s0, $s1		#subtracts $s1 from $s0 and stores it in $t1 ($t1 = $s1 - $s0)
addi $t2, $s2, -4		#adds $s2 and -4 and stores it in $t2 ($t2 = $s2 - 4)
add $t3, $t2, $t1		#adds $t2 and $t1 and stores it in $t3 ($t3 = $t1 + $t0)
sw $t3, 8($t0)			#stores $t3 in 0x10010008 (8 displacement from $t0)
#Step 7
#print name
addi $v0, $zero, 4		#puts the command to print a string into $v0
lui $a0, 0x1001			#initializes $a0 to start of .data
addi $a0, $a0, 12		#puts the str1 pointer into $a0 to be printed
syscall				#prints str1 after reading previous 2 lines
#skip line
addi $v0, $zero, 4		#puts the command to print a string into $v0
lui $a0, 0x1001			#initializes $a0 to start of .data
addi $a0, $a0, 42		#puts the str3 pointer into $a0 to be printed
syscall				#prints str3 after reading previous 2 lines
#print val1
addi $v0, $zero, 4
lui $a0, 0x1001
syscall
#next line
addi $v0, $zero, 4
lui $a0, 0x1001
addi $a0, $a0, 42
syscall
#print val2
addi $v0, $zero, 4
lui $a0, 0x1001
addi $a0, $a0, 4
#next line
addi $v0, $zero, 4
lui $a0, 0x1001
addi $a0, $a0, 42
syscall
#print val3
addi $v0, $zero, 4
lui $a0, 0x1001
addi $a0, $a0, 8
#Step 8
