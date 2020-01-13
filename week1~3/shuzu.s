.text
.globl main
main:
	la $t0, nums

	loop:
		beq $t1, 10, result
		
		lw $t3, 0($t0)
		add $t2, $t2, $t3
		addi $t0, $t0, 4
		add $t1, $t1, 1
		
		j loop
	
	result:
		move $a0, $t2
		li $v0, 1
		syscall

		li $v0, 10
		syscall
.data
	nums:
		.word 21 4 12 6 89 17 33 10 9 51
