#!/usr/bin/bash

set -e

# ./run.sh directory program_name
as --32 -o build/$2.o $1/$2.s
ld -m elf_i386 -o bin/$2.out build/$2.o
# ./bin/$1.out
