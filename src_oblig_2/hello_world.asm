; Hello Word in nasm
; Constants
cr equ 13
lf equ 10
; define a constant cr (carriage-return) equal to 13
; define a constant lf (line-feed) equal to 10
section .data
message db "Hello World!",cr,lf
length equ $ - message ; start writing the .data segment

section .text
global _start

_start:
    mov edx,length
    mov ecx,message
    mov ebx,1
    mov eax,4
    int 80h
    mov ebx,0
    mov eax,1
    int 80h ; start writing the .text segment
    ; declare _start as a global symbol
    ; create the label _start
    ; system call 4 in x86 Linux kernel is sys_write
    ; system call 1 in x86 Linux kernel is sys_exit