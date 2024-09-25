# ./upper-file input-file output-file
#
# Writes input-file content to output-file by making all characters uppercase

.section .bss
.equ buffer_size, 500
.lcomm buffer_data, buffer_size

.section .data
# https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86-32_bit
.equ LINUX_INT, 0x80
.equ EXIT_SYSCALL, 1
.equ READ_SYSCALL, 3
.equ WRITE_SYSCALL, 4
.equ OPEN_SYSCALL, 5
.equ CLOSE_SYSCALL, 6
.equ O_RDONLY, 0
.equ O_WRONLY_CR_TRUNC, 03101

.section .text
.equ ARGC, 0
.equ ARGV_1, 8
.equ ARGV_2, 12

.globl _start

_start:
movl %esp, %ebp
subl $8, %esp

open_input:
movl $OPEN_SYSCALL, %eax
movl ARGV_1(%ebp), %ebx
movl $O_RDONLY, %ecx
movl $0666, %edx
int $LINUX_INT

# -4(%ebp) = Input file descriptor
movl %eax, -4(%ebp)

open_output:
movl $OPEN_SYSCALL, %eax
movl ARGV_2(%ebp), %ebx
movl $O_WRONLY_CR_TRUNC, %ecx
movl $0666, %edx
int $LINUX_INT

# -8(%ebp) = Output file descriptor
movl %eax, -8(%ebp)

read_file_into_buffer:
movl $READ_SYSCALL, %eax
movl -4(%ebp), %ebx
movl $buffer_data, %ecx
movl $buffer_size, %edx
int $LINUX_INT

cmpl $0, %eax
je close_inp_out_files

write_buffer_into_file:
pushl $buffer_data
pushl %eax
call make_buffer_uppercase
popl %eax
addl $4, %esp

movl -8(%ebp), %ebx
movl $buffer_data, %ecx
movl %eax, %edx
movl $WRITE_SYSCALL, %eax
int $LINUX_INT

jmp read_file_into_buffer

close_inp_out_files:
movl $CLOSE_SYSCALL, %eax
movl -4(%ebp), %ebx
int $LINUX_INT

movl $CLOSE_SYSCALL, %eax
movl -8(%ebp), %ebx
int $LINUX_INT

exit:
movl %ebp, %esp
movl $1, %eax
movl $0, %ebp
int $LINUX_INT

# (arg1: buffer address, arg2: buffer size)
.type make_buffer_uppercase, @function
make_buffer_uppercase:
pushl %ebp
movl %esp, %ebp

# move buffer data to %eax
movl 12(%ebp), %eax
# move buffer size to %ecx
movl 8(%ebp), %ebx
movl $0, %edi

cmpl $0, %ebx
je completed

start_convert:
cmpl %edi, %ebx
je completed

movb (%eax, %edi, 1), %cl
cmpb $97, %cl
jl copying
cmpb $122, %cl
jg copying

subb $97, %cl
addb $65, %cl

copying:
movb %cl, (%eax, %edi, 1)
incl %edi
jmp start_convert

completed:
movl %ebp, %esp
popl %ebp
ret
