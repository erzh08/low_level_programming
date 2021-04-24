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
	movzx r9, byte[rdi+rcx]		; movzx = move with zero extend
	cmp r9b, '0'			; se menor que char '0', termina
	jb .end
	cmp r9b, '9'			; se maior que char '9', termina
	ja .end
	xor rdx, rdx
	mul r8				; multiplica rax por 10 (1 -> 10)
	and r9b, 0x0f			; converte o char dec para o num equivalente
	add rax, r9			; soma o novo num (10 + 5 -> 15)
	inc rcx				; aumenta rcx (posicao na string)
	jmp .loop
.end:
	mov rdx, rcx	
    ret

fib:
	dec rdi
	mov rax, 1
	xor rbx, rbx
	xor rdx, rdx
.loop:
	cmp rdi, 0
	je .end
	mov rdx, rax
	add rax, rbx
	mov rbx, rdx
	dec rdi
	jmp .loop
.end:
    ret

_start:
	; open
	mov rax, 2
	mov rdi, fname
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall

	; mmap
	mov r8, rax
	mov rax, 9
	mov rdi, 0			; OS escolhe
	mov rsi, 4096
	mov rdx, PROT_READ
	mov r10, MAP_PRIVATE
	mov r9, 0
	syscall

	mov rdi, rax
	call parse_uint

	mov rdi, rax
	call fib

	;exit
	mov rdi, rax
	mov rax, 60
	syscall
