#!/usr/bin/bash

set -e

as --32 -o build/$1.o $1.s
ld -m elf_i386 -o bin/$1.out build/$1.o
# ./bin/$1.out
