# Finding maximum number from given sequence

.section .data

sequence:
  .long 3, 10, 2, 12, 40, 8, 7, 6, 5, 23

.section .text

.globl _start
_start:

movl $0, %edi
movl sequence(,%edi,4), %ebx

loop_start:
  incl %edi
  cmpl $10, %edi
  je loop_end
  movl sequence(,%edi,4), %eax
  cmpl %ebx, %eax
  jle loop_start

  movl %eax, %ebx
  jmp loop_start

loop_end:
  movl $1, %eax
  int $0x80
