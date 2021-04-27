#!/bin/sh
nasm -f elf main.asm
ld -m elf_i386 -s -o out main.o #/usr/lib32/libc.a
./out