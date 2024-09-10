#!/usr/bin/bash

set -e

as --32 -o $1.o $1.s
ld -m elf_i386 -o $1.out $1.o
./$1.out
