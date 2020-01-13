###########################################################################
#
#    #include<iostream>
#    using namespace std;
#
#    void swap(int &a, int &b){
#	int temp;
#	temp = a;
#	a = b;
#	b = temp;
#    }
#
#    void sort(int num[10]) {
#        for(int i = 0; i < 10; ++i)
#	for(int j = i - 1; j > 0; --j)
#	    if(nums[j] > nums[j + 1])
#	        sawp(nums[j], nums[j + 1])
#    }
#
#    int main() {
#      int n = 10;
#      int nums[10];
#      for(int i = 0; i < 10; ++1)
#	cin >> nums[i];
#      sort(nums);
#      cout << result << endl;
#      return 0;
#    }
#
###########################################################################

.text
.globl main

main:
	addi $s0, $0, 11		#���鳤�ȱ�����s0, ������λ��Ҫ, ����Ϊ(n - 1)
	la $a0, input		#��ʾ�û���ʼ��������
	li $v0, 4
	syscall

	#����read����
	move $a0, $gp
	move $a1, $s0
	jal read

	#����sort����
	move $a0, $gp
	move $a1, $s0
	jal sort

	#����print����
	move $a0, $gp
	move $a1, $s0
	jal print

read:
	addi $sp, $sp, -4		#��һλΪ����Ԫ�ظ���
	sw $s0, 0($sp)
	li $s0, 1			#��s0��Ϊ1, ����������

	real_read:
		sltu $t0, $s0, $a1	#s0 < a1ʱ t0 == 1 ��������
		beq $t0, $0, exit_read
		
		mul $t0, $s0, 4	#ȡ����һλ�ĵ�ַ
		add $t0, $a0, $t0
		move $t1, $a0	#�������Ӱ��a0, ���԰�a0�ŵ�t1����
		li $v0, 5
		syscall
		
		sw $v0, 0($t0)
		move $a0, $t1	#���������ָ�a0
		addi $s0, $s0, 1
		j real_read
		
	exit_read:
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		jr $ra

print:
	la $a0, output
	li $v0, 4
	syscall
	
	addi $sp, $sp, -4		#��һλΪ����Ԫ�ظ���
	sw $s0, 0($sp)
	li $s0, 1			#��s0��Ϊ1, ����������

	real_print:
		sltu $t0, $s0, $a1	#s0 < a1ʱ t0 == 1 ��������
		beq $t0, $0, exit_print
		
		mul $t0, $s0, 4	#ȡ����һλ�ĵ�ַ
		add $t0, $a0, $t0
		move $t1, $a0	#�������Ӱ��a0, ���԰�a0�ŵ�t1����
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		la $a0, blank
		li $v0, 4
		syscall
		
		sw $v0, 0($t0)
		move $a0, $t1	#����������ָ�a0
		addi $s0, $s0, 1
		j real_print
		
	exit_print:
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		jr $ra

sort:
	addi $sp, $sp, -20
	sw $ra, 16($sp)			#���ص�ַ
	sw $s3, 12($sp)			#�����С
	sw $s2, 8($sp)			#�����ַ
	sw $s1, 4($sp)			#j
	sw $s0, 0($sp)			#i

	move $s2, $a0
	move $s3, $a1
	move $s0, $zero			#i = 0

	for_out:
		slt $t0, $s0, $s3		#��� i < n, �� t0 = 1
		beq $t0, $zero, exit_out	#��� t0 = 0, ��ת��exit1�˳����ѭ��
		addi $s1, $s0, -1		#j = i - 1

	for_in:
		slti $t0, $s1, 0		#��� j < 0, ��t0 = 1
		bne $t0, $zero, exit_in	#���t0 != 0, ��ת��exit2 (�������ѭ��)

		sll $t1, $s1, 2		
		add $t2, $s2, $t1		
		lw $t3, 0($t2)		#ȡ��arr[j]�����ݵ�$t3
		lw $t4, 4($t2)		#ȡ��arr[j + 1]�����ݵ�$t4

		slt $t0, $t3, $t4		#���arr[j] < arr[j + 1], ��t0 = 1
		beq $t0, $zero, exit_in	#��������������, ����ת��exit2�˳��ڲ�ѭ��

		move $a0, $s2		#�Ѳ������浽a0, a1���㴫��swap����
		move $a1, $s1		
		jal swap
		addi $s1, $s1, -1		#j--
		j for_in

	swap:
		sll $t0, $a1, 2		#ȡ��ַ
		add $t0, $a0, $t0	
	
		lw $t1, 0($t0)		#����
		lw $t2, 4($t0)		
		sw $t1, 4($t0)		
		sw $t2, 0($t0)		
		jr $ra			#���ص���ǰ�ĵ�ַ��
	
	exit_in:
		addi $s0, $s0, 1		#i++
		j for_out			#��ת�����ѭ��

	exit_out:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
		
.data
	input:
		.asciiz "������Ҫ�������: \n"
	output:
		.asciiz "\n����Ľ��Ϊ: \n"
	blank:
		.asciiz " "
		