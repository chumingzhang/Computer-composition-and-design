###########################################################################
#
#    #include<iostream>
#    using namespace std;
#    int jie_cheng(int n) {
#        if (n == 1) {
#            return 1;
#        }
#        return jiecheng(n - 1);
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
#ȫ��ѹջ, ���һ����

.text
.globl main

main:
	lw $a0, n
	addi $s1, $0, 1	#s1��Ϊ1, ����Ƚ�
	addi $v0, $0, 1	#v0��Ϊ1, ������
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

	beq $a0, $s1, L1	#��num == 1 ʱ, ֹͣ�ݹ�

	addi $a0, $a0, -1
	jal fact

L1:
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	mul $v0, $a0, $v0	#v0��Ŵ�
	jr $ra

.data
	n:
		.word 10