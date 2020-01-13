###########################################################################
#
#    #include<iostream>
#    using namespace std;
#    int jie_cheng(int n) {
#        if (n != 1) {
#            return n * jie_cheng(n - 1);
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
#全部压栈, 最后一起算

.text
.globl main

main:
	lw $a0, n
	addi $s1, $0, 1	#s1置为1, 方便比较
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

	bne $a0, $s1, L1	#当num != 1 时, 递归且计算

	mul $v0, $a0, 1
	addi $sp, $sp, 8
	jr $ra

L1:
	addi $a0, $a0, -1
	jal fact

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	mul $v0, $a0, $v0	#v0存放答案
	jr $ra

.data
	n:
		.word 10