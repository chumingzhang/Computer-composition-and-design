.text
.globl main
main:
	#������ֵ
	addi $s0, $0, 1
	addi $s1, $0, 1

	#���������ֵ
	move $a0, $s0
	li $v0, 1
	syscall
	la $a0, black
	li $v0, 4
	syscall

	move $a0, $s1
	li $v0, 1
	syscall
	la $a0, black
	li $v0, 4
	syscall

	addi $a1 $0, 0
	jal next
	
	li $v0, 10
	syscall

#һ������
next:
	add $s0, $s0, $s1
	add $s1, $s1, $s0

	move $a0, $s0
	li $v0, 1
	syscall
	la $a0, black
	li $v0, 4
	syscall

	move $a0, $s1
	li $v0, 1
	syscall
	la $a0, black
	li $v0, 4
	syscall

	addi $a1, $a1, 1
	slti $t0, $a1, 10
	bne $t0, $0, next
	jr $ra

.data
	black:
		.asciiz " "