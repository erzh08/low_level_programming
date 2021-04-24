global _start

section .text
_start:
	mov rax, 60	; syscall 'exit'
	mov rdi, 1	; returns 1, simulating false
	syscall
