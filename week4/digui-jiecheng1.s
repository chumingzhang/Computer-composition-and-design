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

	move $a0, $v0	#������
	li $v0, 1
	syscall
	li$v0, 10
	syscall

fact:
	addi $sp, $sp, -8
	sw $ra, 4($sp)	#���ص�ַҲҪѹջ, ����ݹ����
	sw $a0, 0($sp)	#��ǰnumѹջ, ����ݹ����

	slti $t0, $a0, 1	#�жϵ�ǰ num �� 1 �Ĵ�С��ϵ
	beq $t0, $0, L1	#��num > 1 ʱ,�����ݹ����

	#��num <= 1 ʱ,�����ݹ����
	addi $v0, $zero, 1	#����1
	addi $sp, $sp, 8	#���ջ�ռ�
	jr $ra

L1:
	addi $a0, $a0, -1	#num--
	jal fact		#�����ݹ����
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	mul $v0, $a0, $v0	#v0��Ŵ�
	jr $ra

.data
	n:
		.word 10