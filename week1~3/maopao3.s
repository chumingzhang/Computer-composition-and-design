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
#$gp存数组基址
#$s0存数组大小s
#函数调用的时候分别传给a0和a1

main:
	addi $s0, $0, 10
	la $a0, input	#提示用户开始输入数据
	li $v0, 4
	syscall

	#调用read函数
	move $a0, $gp	#把$gp作为参数传递给read函数拿到数组基址, 不要认为现在gp里面是空
	move $a1, $s0	
	jal read		#跳转到read函数的同时保存主函数地址到$ra

	#调用排序函数
	move $a0, $gp
	move $a1, $s0
	jal sort

	#调用输出函数
	li $v0, 4
	la $a0, output
	syscall

	move $a0, $gp
	move $a1, $s0
	jal prinf
	
#从控制台读数据的read函数
read:
	addi $sp, $sp, -4	#栈中开辟1个新地址保存数组元素个数
	sw $s0, 0($sp)
	li $s0, 0		#把s0寄存器清零, 作为读数个数的计数器

	#下面是利用跳转语句和条件控制的读数循环
	#t0做判断标志位, t1做存储地址
	read_1:
		sltu $t0, $s0, $a1		#s0 < a1 则 t0 = 1(否则为0), 即已读入的数的个数小于用户输入为真
		beq $t0, $zero, exit_1	#t0 = zero, 则跳转到exit_1(停止输入)

		sll $t0, $s0, 2		#s0左移两位, 即地址加4
		add $t1, $a0, $t0		#a0加上t0生成新地址
		move $t2, $a0		#读书可能影响a0, 所以把a0放到t2保存(可有可无)
		li $v0, 5			#读数
		syscall

		sw $v0, 0($t1)		#保存读入的数据到主存
		move $a0, $t2		#返回a0(可有可无)
		addi $s0, $s0, 1		#s0++
		j read_1
	exit_1:
		lw $s0, 0($sp)		#把栈里面的东西(数组大小)写回寄存器
		addi $sp, $sp, 4		#弹栈, 就是堆栈的指针归位
		jr $ra

#排序函数
sort:
	addi $sp, $sp, -20			#在栈中开辟5个新地址
	#一次把要用变量的位置定出来并压栈
	sw $ra, 16($sp)			#返回地址
	sw $s3, 12($sp)			#数组大小
	sw $s2, 8($sp)			#数组基址
	sw $s1, 4($sp)			#j
	sw $s0, 0($sp)			#i

	move $s2, $a0
	move $s3, $a1
	move $s0, $zero			#i = 0

	forOut:
		slt $t0, $s0, $s3		#如果 i < n, 则 t0 = 1
		beq $t0, $zero, exit1	#如果 t0 = 0, 跳转到exit1退出外层循环
		addi $s1, $s0, -1		#j = i - 1

	forIn:
		slti $t0, $s1, 0		#如果 j < 0, 则t0 = 1
		bne $t0, $zero, exit2	#如果t0 != 0, 跳转到exit2 (跳到外层循环)

		sll $t1, $s1, 2		#$t1 = j * 4
		add $t2, $s2, $t1		#$t2存了arr[j]的地址
		lw $t3, 0($t2)		#取出arr[j]的数据到$t3
		lw $t4, 4($t2)		#取出arr[j + 1]的数据到$t4
		slt $t0, $t3, $t4		#如果arr[j] < arr[j + 1], 则t0 = 1
		beq $t0, $zero, exit2	#不满足上面条件, 则跳转到exit2退出内层循环
		move $a0, $s2		#把数据地址这个参数传给swap函数
		move $a1, $s1		#另一个参数j也传过去
		jal swap
		addi $s1, $s1, -1		#j--
		j forIn
	
	exit2:
		addi $s0, $s0, 1		#i++
		j forOut			#跳转至外层循环

	exit1:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
	
	swap:
		sll $t0, $a1, 2		#j左移两位放到t0中
		add $t0, $a0, $t0		#基址值加上偏移量arr[j]的地址
		lw $t1, 0($t0)		#把arr[j]的值放入t1中
		lw $t2, 4($t0)		#把arr[j + 1]的值放入t2中
		sw $t1, 4($t0)		#arr[j] = arr[j + 1]
		sw $t2, 0($t0)		#arr[j + 1] = arr[j]
		jr $ra			#返回调用前的地址处

#输出函数等prinf的部分,  实现基本同读入
prinf:
	addi $sp, $sp, -4
	sw $s0, 0($sp)		#保存寄存器s0, s1
	li $s0, 0			#将s0置零

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
		.asciiz "请输入要排序的数: \n"
	output:
		.asciiz "\n排序的结果为: \n"