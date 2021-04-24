global _start

section .data
codes: db '0123456789ABCDEF'
newline_char: db 10

section .text
_start:
	mov rax, 0x1122334455667788
	mov rdi, 1
	mov rdx, 1
	mov rcx, 64
; inicio do loop
.loop:
	push rax
	sub rcx, 4

	sar rax, cl		; shift arithmetic right com cl (menor parte de rcx)

	and rax, 0xf		; mantem apenas os 4 bits mais significativos

	lea rsi, [codes+rax]	; passa o end. do char em codes na posic. rax

	mov rax, 1

	push rcx
	syscall
	pop rcx
	pop rax

	test rcx, rcx
	jnz .loop
; fim do loop

	push rcx
	push rax
	mov rax, 1
	mov rsi, newline_char
	syscall
	pop rax
	pop rcx

	mov rax, 60
	xor rdi, rdi
	syscall
