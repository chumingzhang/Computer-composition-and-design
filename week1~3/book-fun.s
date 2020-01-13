.text
.globl main

main:
	lw $a0, g
	lw $a1, h
	lw $a2, i
	lw $a3, k
	jal leaf_example
	
leaf_example:
	addi $sp, $sp, -12
	sw $t1, 8($sp)
	sw $t0, 4($sp)
	sw $s0, 0($sp)

	add $t0, $a0, $a1
	add $t1, $a2, $a3
	sub $s0, $t0, $t1

	move $a0, $s0
	li $v0, 1
	syscall
	li $v0, 10
	syscall

	lw $s0, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

.data
	g:
		.word 3
	h:
		.word 17
	i:
		.word 5
	k:
		.word 12