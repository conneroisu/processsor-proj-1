#Some starting data in memory to test things
.data 
arr: .word 0x10, 0x20, 0x18, 0x28, 0x8, 0x0, 0x10

.text
.globl main

main: 
#Where A is an array of ints
#la $s0, arr #base Address of array A <-- Load the memory and maybe change this
lui $s0, 4097
addi $s1, $0, 6	#Len of array A 
addi $t0, $0, 0
ori $s0, 0




#addi $s1, $s1, -1 #$s1 = A.len() - 1 Just put the right amount in at the start


#  $t0 = i
#  $t1 = j

Outer:
	slt $at, $t0, $s1
	beq $at, $0 Exit #branches when $t0 > $s1	exits when i>N
	addi $t7, $s0, 0 #temp holding the Base Addr of A. I will increase this in parallel with J. 
	sub $t3, $s1, $t0 #Find $t3 = (n-i) (number of elements - outer iterator) index past which the array is sorted
	addi $t1, $0, 0 #j
	Inner:  
		slt $at, $t1, $t3
		#Do Logic "Set-up"
		lw $t4, 0($t7) #A[j]
		lw $t5, 4($t7) #A[j+1]
		beq $at, $0 BackToOuter #branches when not set so; t1 > t0
		slt $at,  $t5, $t4 #A[j+1] < A[j] then swap them; Set if j=1 < j
		beq $at, $0, EndJ #goes back to the outer loop
		sw $t5, 0($t7)
		sw $t4, 4($t7)
		EndJ:
		addi $t1, $t1, 1 #j++
		addi $t7, $t7, 4 #go to next element in A  
		j Inner
	
		
	BackToOuter: 
	addi $t0, $t0, 1
	j Outer
Exit:
halt
