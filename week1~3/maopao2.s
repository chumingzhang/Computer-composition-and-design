.text
.globl main
main:
	li $v0,5  			# �����û���������鳤��
	syscall

	la $t6,array    		# $t6 �������׵�ַ
	move $t7, $zero   		# $t7 ��ѭ������i
	move $t8, $v0      		# $t8 �����鳤��
	move $t9, $zero  		# $t9 ��ѭ������ j
	
input:              
	li $v0,5
 	syscall

	addu $t1, $t0, $t6		# ��ȡ��һ����ַ
	sw $v0, 0($t1)

	addi, $t0, $t0, 4
	addi $t7, $t7, 1
	blt $t7, $t8, input		# �������С�����鳤��, ��������(blt--С������ת)

	move $t7, $zero		# ��������ѭ������t7, t0��Ϊ0������Ϊ��һ��ѭ����ѭ���������Խ�ʡ�Ĵ���
	move $t0, $zero

loop1:
	move $t9, $zero
loop2:
	move $t0, $t9		# �� j (t9) ����t0

	mul $t0, $t0, 4		# ��ȡa[j]
	addu $t1, $t0, $t6
	lw $t2, 0($t1)

	addi $t0, $t9, 1		# ��ȡa[j+1]
	mul $t0, $t0, 4
	addu $t4, $t0, $t6		
	lw $t3, 0($t4)
	
	bge $t2, $t3, skip  		# ���a[j] >= a[j + 1],��ת��skip�����
	sw $t3, 0($t1)   		# �����ִ�����������䣬�������ߵ�ֵ
	sw $t2, 0($t4)
	
	move $t0, $zero		# ��ѭ��������t0��Ϊ0������Ϊ��һ��ѭ����ѭ���������Խ�ʡ�Ĵ���

skip:
	addi $t9, $t9, 1   		# �ڲ�ѭ���������������ж��Ƿ�����ѭ������
	addi $t0, $t9, 1   		# t0 = j
	sub $t1, $t8, $t7    		# t1 = len - i
	blt $t0, $t1, loop2  		# ��� j < len - i, ������ڲ�ѭ��

	addi $t7, $t7, 1     		# ��������㣬�����ѭ����ѭ���������������ж��Ƿ�����ѭ������
	sub $t2, $t8, 1		# t2 = len - 1
	blt $t7, $t2, loop1		# ��� i < len - 1������ת��loop1, �������ѭ��
				

output:
	move $t7, $zero   		# ��ѭ��������Ϊ0��������һѭ������ʡ�Ĵ���

print: 
	move $t0, $t7
	mul $t0, $t0, 4
	addu $t1,$t0, $t6
	lw $a0, 0($t1)
	li $v0, 1
	syscall

	la $a0, seperate  		# �ָ�����Ԫ��
	li $v0, 4
	syscall

	addi $t7, $t7, 1
	blt $t7, $t8, print   		# �������ѭ����������ת��print����ִ��ѭ��

.data
	array:
		.space 1024
	seperate:
		.asciiz  "  "