# Recursive power function that sums two different results of power function
# 5^2 + 3^3 = 25 + 27 = 52

.section .data

.section .text

.globl _start
_start:

  pushl $2
  pushl $5
  call power
  add $8, %esp

  pushl %eax

  pushl $3
  pushl $3
  call power
  add $8, %esp

  movl %eax, %ebx
  popl %eax
  addl %eax, %ebx

  movl $1, %eax
  int $0x80

# power(arg1: base, arg2: pow)
.type power, @function
power:
  pushl %ebp
  movl %esp, %ebp

  movl 8(%ebp), %ebx
  movl 12(%ebp), %ecx

  cmpl $1, %ecx
  je last_step

  decl %ecx
  pushl %ecx
  pushl %ebx
  call power
  addl $8, %esp

  imull %ebx, %eax

  jmp return

last_step:
  movl %ebx, %eax
  jmp return

return:
  movl %ebp, %esp
  popl %ebp
  ret
