%define stdout 1

%define	SYS_exit	1
%define	SYS_write	4

section	.text
align 4
access.the.bsd.kernel:
	int	80h
	ret

%macro	system	1
	mov	eax, %1
	call	access.the.bsd.kernel
%endmacro

%macro	sys.exit	0
	system	SYS_exit
%endmacro

%macro	sys.write	0
	pop		ebx
	pop		ecx
	pop		edx
	system	SYS_write
%endmacro
