.text
.globl main

main:
	addi $t4, $zero, 9		# i ��ʼ��Ϊ9
loop1:
	la $t1, sortarry    		# �������鵱ǰ��ַ�� t1
	addi $t6,$zero,0     		# ��ʼ�� j = 0

loop2:
	lw $t0, 0($t1)      		# t0 = array[j]
 	lw $t7, 4($t1)      		# t7 = array[j + 1]
 	slt  $t2,$t7,$t0     		# array[j + 1] >= array[j]ʱ, t2 = 0(������)
 	beq $t2, $zero skip2      	# t2 = 0 -> skip2
	
    	sw $t7, 0($t1)     		#  array[j] = array[j + 1]--��1��Ԫ�ظ�Ϊt7
    	sw $t0, 4($t1)     		#  array[j + 1] = array[j]--��2��Ԫ�ظ�Ϊt0

skip2:
	addi $t6, $t6, 1        	# j = j + 1 
 	addi $t1, $t1, 4		# �׵�ַ������һλ
 	slt $t2, $t4, $t6      		# i > j, t2 = 0
 	beq $t2, $zero loop2   	# t2 = 0 -> loop2(i > j �����ڶ���ѭ��)

 	addiu $t4, $t4, -1        	# i = i - 1 


#����ȫ���	
#	addi $t5, $zero, 10
#	la $s0, sortarry
#	output:
#		lw $a0, 0($s0)		
#		li $v0,1             
#		syscall
#		la $a0, seprate
#		li $v0,4 
#		syscall
#
#		addi $s0, $s0, 4
#		addi $t5, $t5, -1
#		bne $t5, $zero, output
#
#	la $a0, change
#	li $v0, 4
#	syscall 

	#�����ֵ���
	lw $a0, 0($t1)		
	li $v0,1             
	syscall
	la $a0, seprate
	li $v0,4 
	syscall

 	bne  $t4, $zero, loop1	# �ж� i �Ƿ�Ϊ 0, ��Ϊ0�������һ��ѭ��

 	la $t1, sortarry        		# ����ѭ��,������һ��ֵ
 	lw $a0, 0($t1)
 	li $v0,1
 	syscall
 	li $v0,10
 	syscall 

.data
	sortarry:
		.word 15,23,14,25,60,10,9,11,60,40
	seprate:
		.asciiz " > "