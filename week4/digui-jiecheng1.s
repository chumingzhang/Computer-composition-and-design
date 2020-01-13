###########################################################################
#
#    #include<iostream>
#    using namespace std;
#    int jie_cheng(int n) {
#        if (n > 1) {
#            jie_cheng(n - 1);
#        }
#        return 1;
#    }
#
#    int main() {
#      int n;
#      cin >> n;
#      int result = jiecheng(n);
#      cout << result << endl;
#      return 0;
#    }
#
###########################################################################

.text
.globl main

main:
	lw $a0, n
	jal fact

	move $a0, $v0	#输出结果
	li $v0, 1
	syscall
	li$v0, 10
	syscall

fact:
	addi $sp, $sp, -8
	sw $ra, 4($sp)	#返回地址也要压栈, 方便递归调用
	sw $a0, 0($sp)	#当前num压栈, 方便递归调用

	slti $t0, $a0, 1	#判断当前 num 和 1 的大小关系
	beq $t0, $0, L1	#当num > 1 时,继续递归调用

	#当num <= 1 时,结束递归调用
	addi $v0, $zero, 1	#返回1
	addi $sp, $sp, 8	#清除栈空间
	jr $ra

L1:
	addi $a0, $a0, -1	#num--
	jal fact		#继续递归调用
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	mul $v0, $a0, $v0	#v0存放答案
	jr $ra

.data
	n:
		.word 10