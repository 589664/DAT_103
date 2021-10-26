#!/bin/bash

nasm -f elf -F dwarf -g Asm1.asm

ld -m elf_i386 -o Asm1 Asm1.o

rm input

(cat A1.mat B2.mat | ./toBinary)> input

# test jumptrace (cat A7.mat | ./toBinary | ./Asm1)