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
#    int sort(int num[10]) {
#        for(int i = 0; i < 10; ++i)
#	for(int j = i - 1; j > 0; --j)
#	    if(nums[j] < nums[j + 1])
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
#$gp�������ַ
#$s0�������Сs
#�������õ�ʱ��ֱ𴫸�a0��a1

main:
	addi $s0, $0, 10
	la $a0, input	#��ʾ�û���ʼ��������
	li $v0, 4
	syscall

	#����read����
	move $a0, $gp	#��$gp��Ϊ�������ݸ�read�����õ������ַ, ��Ҫ��Ϊ����gp�����ǿ�
	move $a1, $s0	
	jal read		#��ת��read������ͬʱ������������ַ��$ra

	#����������
	move $a0, $gp
	move $a1, $s0
	jal sort

	#�����������
	li $v0, 4
	la $a0, output
	syscall

	move $a0, $gp
	move $a1, $s0
	jal prinf
	
#�ӿ���̨�����ݵ�read����
read:
	addi $sp, $sp, -4	#ջ�п���1���µ�ַ��������Ԫ�ظ���
	sw $s0, 0($sp)
	li $s0, 0		#��s0�Ĵ�������, ��Ϊ���������ļ�����

	#������������ת�����������ƵĶ���ѭ��
	#t0���жϱ�־λ, t1���洢��ַ
	read_1:
		sltu $t0, $s0, $a1		#s0 < a1 �� t0 = 1(����Ϊ0), ���Ѷ�������ĸ���С���û�����Ϊ��
		beq $t0, $zero, exit_1	#t0 = zero, ����ת��exit_1(ֹͣ����)

		sll $t0, $s0, 2		#s0������λ, ����ַ��4
		add $t1, $a0, $t0		#a0����t0�����µ�ַ
		move $t2, $a0		#�������Ӱ��a0, ���԰�a0�ŵ�t2����(���п���)
		li $v0, 5			#����
		syscall

		sw $v0, 0($t1)		#�����������ݵ�����
		move $a0, $t2		#����a0(���п���)
		addi $s0, $s0, 1		#s0++
		j read_1
	exit_1:
		lw $s0, 0($sp)		#��ջ����Ķ���(�����С)д�ؼĴ���
		addi $sp, $sp, 4		#��ջ, ���Ƕ�ջ��ָ���λ
		jr $ra

#������
sort:
	addi $sp, $sp, -20			#��ջ�п���5���µ�ַ
	#һ�ΰ�Ҫ�ñ�����λ�ö�������ѹջ
	sw $ra, 16($sp)			#���ص�ַ
	sw $s3, 12($sp)			#�����С
	sw $s2, 8($sp)			#�����ַ
	sw $s1, 4($sp)			#j
	sw $s0, 0($sp)			#i

	move $s2, $a0
	move $s3, $a1
	move $s0, $zero			#i = 0

	forOut:
		slt $t0, $s0, $s3		#��� i < n, �� t0 = 1
		beq $t0, $zero, exit1	#��� t0 = 0, ��ת��exit1�˳����ѭ��
		addi $s1, $s0, -1		#j = i - 1

	forIn:
		slti $t0, $s1, 0		#��� j < 0, ��t0 = 1
		bne $t0, $zero, exit2	#���t0 != 0, ��ת��exit2 (�������ѭ��)

		sll $t1, $s1, 2		#$t1 = j * 4
		add $t2, $s2, $t1		#$t2����arr[j]�ĵ�ַ
		lw $t3, 0($t2)		#ȡ��arr[j]�����ݵ�$t3
		lw $t4, 4($t2)		#ȡ��arr[j + 1]�����ݵ�$t4
		slt $t0, $t3, $t4		#���arr[j] < arr[j + 1], ��t0 = 1
		beq $t0, $zero, exit2	#��������������, ����ת��exit2�˳��ڲ�ѭ��
		move $a0, $s2		#�����ݵ�ַ�����������swap����
		move $a1, $s1		#��һ������jҲ����ȥ
		jal swap
		addi $s1, $s1, -1		#j--
		j forIn
	
	exit2:
		addi $s0, $s0, 1		#i++
		j forOut			#��ת�����ѭ��

	exit1:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
	
	swap:
		sll $t0, $a1, 2		#j������λ�ŵ�t0��
		add $t0, $a0, $t0		#��ֵַ����ƫ����arr[j]�ĵ�ַ
		lw $t1, 0($t0)		#��arr[j]��ֵ����t1��
		lw $t2, 4($t0)		#��arr[j + 1]��ֵ����t2��
		sw $t1, 4($t0)		#arr[j] = arr[j + 1]
		sw $t2, 0($t0)		#arr[j + 1] = arr[j]
		jr $ra			#���ص���ǰ�ĵ�ַ��

#���������prinf�Ĳ���,  ʵ�ֻ���ͬ����
prinf:
	addi $sp, $sp, -4
	sw $s0, 0($sp)		#����Ĵ���s0, s1
	li $s0, 0			#��s0����

	prinf_1:
		sltu $t0, $s0, $a1
		beq $t0, $zero, exit_2
		sll $t0, $s0, 2
		add $t1, $a0, $t0
		move $t2, $a0
		lw $a0, 0($t1)
		li $v0, 1
		syscall

		li $a0, ','
		li $v0, 11
		syscall

		move $a0, $t2
		addi $s0, $s0, 1
		j prinf_1

	exit_2:
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		jr $ra

.data
	input:
		.asciiz "������Ҫ�������: \n"
	output:
		.asciiz "\n����Ľ��Ϊ: \n"