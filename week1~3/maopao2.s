.text
.globl main
main:
	li $v0,5  			# 接收用户收入的数组长度
	syscall

	la $t6,array    		# $t6 是数组首地址
	move $t7, $zero   		# $t7 是循环变量i
	move $t8, $v0      		# $t8 是数组长度
	move $t9, $zero  		# $t9 是循环变量 j
	
input:              
	li $v0,5
 	syscall

	addu $t1, $t0, $t6		# 获取下一个地址
	sw $v0, 0($t1)

	addi, $t0, $t0, 4
	addi $t7, $t7, 1
	blt $t7, $t8, input		# 输入个数小于数组长度, 继续输入(blt--小于则跳转)

	move $t7, $zero		# 完成输入后将循环变量t7, t0置为0，可作为下一个循环的循环变量，以节省寄存器
	move $t0, $zero

loop1:
	move $t9, $zero
loop2:
	move $t0, $t9		# 将 j (t9) 存入t0

	mul $t0, $t0, 4		# 获取a[j]
	addu $t1, $t0, $t6
	lw $t2, 0($t1)

	addi $t0, $t9, 1		# 获取a[j+1]
	mul $t0, $t0, 4
	addu $t4, $t0, $t6		
	lw $t3, 0($t4)
	
	bge $t2, $t3, skip  		# 如果a[j] >= a[j + 1],跳转到skip代码块
	sw $t3, 0($t1)   		# 否则就执行下面这两句，交换两者的值
	sw $t2, 0($t4)
	
	move $t0, $zero		# 将循环变量置t0置为0，可作为下一个循环的循环变量，以节省寄存器

skip:
	addi $t9, $t9, 1   		# 内层循环变量自增，且判断是否还满足循环条件
	addi $t0, $t9, 1   		# t0 = j
	sub $t1, $t8, $t7    		# t1 = len - i
	blt $t0, $t1, loop2  		# 如果 j < len - i, 则继续内层循环

	addi $t7, $t7, 1     		# 如果不满足，则将外层循环的循环变量自增，且判断是否还满足循环条件
	sub $t2, $t8, 1		# t2 = len - 1
	blt $t7, $t2, loop1		# 如果 i < len - 1，则跳转到loop1, 继续外层循环
				

output:
	move $t7, $zero   		# 将循环变量置为0，用于下一循环，节省寄存器

print: 
	move $t0, $t7
	mul $t0, $t0, 4
	addu $t1,$t0, $t6
	lw $a0, 0($t1)
	li $v0, 1
	syscall

	la $a0, seperate  		# 分隔数组元素
	li $v0, 4
	syscall

	addi $t7, $t7, 1
	blt $t7, $t8, print   		# 如果满足循环条件，跳转到print继续执行循环

.data
	array:
		.space 1024
	seperate:
		.asciiz  "  "