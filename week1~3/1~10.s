.text
.globl main
main:
	lw $t0, num

	loop:
		add $t1, $t1, $t0
		add $t0, $t0, 1

		beq $t0, 11, result
		j loop

	result:
		move $a0, $t1
		li $v0, 1
		syscall

		li $v0, 10
		syscall

.data
	num:
		.word 1