%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .data
	fname: db 'input.txt', 0

section .text
global _start

parse_uint:
	mov r8, 10
	xor rax, rax
	xor rcx, rcx
.loop:
	movzx r9, byte[rdi+rcx]
	cmp r9b, '0'
	jb .end
	cmp r9b, '9'
	ja .end
	xor rdx, rdx
	mul r8
	and r9b, 0x0f
	add rax, r9
	inc rcx
	jmp .loop
.end:
	mov rdx, rcx
    ret

sum_num:
	mov rax, rdi
	xor r9, r9
	mov r8, 10
.loop:
	xor rdx, rdx
	div r8				; resto em dl
	add r9b, dl
	dec rsi
	cmp rsi, 0
	jz .end
	jmp .loop
.end:
	mov rax, r9
    ret

_start:
	; open
	mov rax, 2			; syscall open
	mov rdi, fname
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall

	; map
	mov r8, rax
	mov rax, 9
	mov rdi, 0
	mov rsi, 4096
	mov rdx, PROT_READ
	mov r10, MAP_PRIVATE
	mov r9, 0
	syscall

	mov rdi, rax
	call parse_uint

	mov rdi, rax
	mov rsi, rdx
	call sum_num

	; exit
	mov rdi, rax
	mov rax, 60
	syscall
