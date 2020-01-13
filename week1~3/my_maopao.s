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
	addi $s0, $0, 11		#数组长度保存在s0, 由于移位需要, 设置为(n - 1)
	la $a0, input		#提示用户开始输入数据
	li $v0, 4
	syscall

	#调用read函数
	move $a0, $gp
	move $a1, $s0
	jal read

	#调用sort函数
	move $a0, $gp
	move $a1, $s0
	jal sort

	#调用print函数
	move $a0, $gp
	move $a1, $s0
	jal print

read:
	addi $sp, $sp, -4		#第一位为数组元素个数
	sw $s0, 0($sp)
	li $s0, 1			#把s0置为1, 当作计数器

	real_read:
		sltu $t0, $s0, $a1	#s0 < a1时 t0 == 1 继续输入
		beq $t0, $0, exit_read
		
		mul $t0, $s0, 4	#取得下一位的地址
		add $t0, $a0, $t0
		move $t1, $a0	#读书可能影响a0, 所以把a0放到t1保存
		li $v0, 5
		syscall
		
		sw $v0, 0($t0)
		move $a0, $t1	#读书结束后恢复a0
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
	
	addi $sp, $sp, -4		#第一位为数组元素个数
	sw $s0, 0($sp)
	li $s0, 1			#把s0置为1, 当作计数器

	real_print:
		sltu $t0, $s0, $a1	#s0 < a1时 t0 == 1 继续输入
		beq $t0, $0, exit_print
		
		mul $t0, $s0, 4	#取得下一位的地址
		add $t0, $a0, $t0
		move $t1, $a0	#读书可能影响a0, 所以把a0放到t1保存
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		la $a0, blank
		li $v0, 4
		syscall
		
		sw $v0, 0($t0)
		move $a0, $t1	#读数结束后恢复a0
		addi $s0, $s0, 1
		j real_print
		
	exit_print:
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		jr $ra

sort:
	addi $sp, $sp, -20
	sw $ra, 16($sp)			#返回地址
	sw $s3, 12($sp)			#数组大小
	sw $s2, 8($sp)			#数组基址
	sw $s1, 4($sp)			#j
	sw $s0, 0($sp)			#i

	move $s2, $a0
	move $s3, $a1
	move $s0, $zero			#i = 0

	for_out:
		slt $t0, $s0, $s3		#如果 i < n, 则 t0 = 1
		beq $t0, $zero, exit_out	#如果 t0 = 0, 跳转到exit1退出外层循环
		addi $s1, $s0, -1		#j = i - 1

	for_in:
		slti $t0, $s1, 0		#如果 j < 0, 则t0 = 1
		bne $t0, $zero, exit_in	#如果t0 != 0, 跳转到exit2 (跳到外层循环)

		sll $t1, $s1, 2		
		add $t2, $s2, $t1		
		lw $t3, 0($t2)		#取出arr[j]的数据到$t3
		lw $t4, 4($t2)		#取出arr[j + 1]的数据到$t4

		slt $t0, $t3, $t4		#如果arr[j] < arr[j + 1], 则t0 = 1
		beq $t0, $zero, exit_in	#不满足上面条件, 则跳转到exit2退出内层循环

		move $a0, $s2		#把参数保存到a0, a1方便传给swap函数
		move $a1, $s1		
		jal swap
		addi $s1, $s1, -1		#j--
		j for_in

	swap:
		sll $t0, $a1, 2		#取地址
		add $t0, $a0, $t0	
	
		lw $t1, 0($t0)		#交换
		lw $t2, 4($t0)		
		sw $t1, 4($t0)		
		sw $t2, 0($t0)		
		jr $ra			#返回调用前的地址处
	
	exit_in:
		addi $s0, $s0, 1		#i++
		j for_out			#跳转至外层循环

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
		.asciiz "请输入要排序的数: \n"
	output:
		.asciiz "\n排序的结果为: \n"
	blank:
		.asciiz " "
		