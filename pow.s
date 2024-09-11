# Program that sums two different results of power function
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


# power (arg1: base, arg2: pow)
.type power, @function
power:
  pushl %ebp
  movl %esp, %ebp
  movl 8(%ebp), %ebx
  movl 12(%ebp), %ecx
  subl $4, %esp
  movl %ebx, -4(%ebp)

loop_start:
  cmpl $0, %ecx
  je case_zero

  cmpl $1, %ecx
  je loop_end

  movl -4(%ebp), %eax
  imull %ebx, %eax
  movl %eax, -4(%ebp)

  decl %ecx
  jmp loop_start

case_zero:
  movl $1, -4(%ebp)
  jmp loop_end

loop_end:
  movl -4(%ebp), %eax
  movl %ebp, %esp
  popl %ebp
  ret

