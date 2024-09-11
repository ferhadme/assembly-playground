# Program finds sum of the maximum values from 3 different max values from 3 different lists
# Maximum value from list is found by using max function

.section .data
list1:
  .long 4, 2, 1, 8
list2:
  .long 3, 10, 11, 7
list3:
  .long 4, 2, 9, 3

# f = 8 + 11 + 9 = 28

.section .text

.globl _start
_start:

pushl $list1
pushl $4
call max
addl $8, %esp

pushl %eax

pushl $list2
pushl $4
call max
addl $8, %esp

popl %ebx
addl %eax, %ebx
pushl %ebx

pushl $list3
pushl $4
call max
addl $8, %esp

popl %ebx
addl %eax, %ebx

movl $1, %eax
int $0x80

# max(add: arg1), where add is address of first element in the list
.type max, @function
max:
  pushl %ebp
  movl %esp, %ebp

  movl 8(%ebp), %ecx
  movl 12(%ebp), %edi
  movl (%edi), %ebx # 4

loop_start:
  decl %ecx
  cmpl $0, %ecx
  je loop_end

  addl $4, %edi
  cmpl %ebx, (%edi)
  jle loop_start

  movl (%edi), %ebx
  jmp loop_start

loop_end:
  movl %ebx, %eax
  movl %ebp, %esp
  popl %ebp
  ret
