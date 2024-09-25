# Finding sum of elements in a sequence
# Output is written to exit status of program ($?)

.section .data

sequence:
  .long 3, 1, 5, 9, 10

.section .text

.globl _start
_start:

movl $0, %edi
movl $0, %ebx

loop_start:
  cmpl $5, %edi
  je loop_end
  addl sequence(,%edi,4), %ebx
  incl %edi
  jmp loop_start

loop_end:
  movl $1, %eax
  int $0x80

