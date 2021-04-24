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

find_prime:
	xor rdx, rdx			; rdx e usado na op. div, entao e zerado
	mov r9, rax
	mov r8, 2
	div r8
	mov r8b, al
	mov rax, r9
	mov r9, 2
	mov rdi, 1
.loop:
	xor rdx, rdx		; sera usado para armazenar o resto 
	cmp rax, 1
	jle .not_prime
	cmp r9b, r8b
	jge .end
	push rax
	div r9			; salva o resto em dl
	pop rax
	cmp dl, 0		; se o resto for 0, nao e primo
	je .not_prime
	inc r9
	jmp .loop
.not_prime:
	xor rdi, rdi
.end:
    ret

_start:
	; read
	mov rax, 2		; syscall read
	mov rdi, fname		; file name
	mov rsi, O_RDONLY	; flags protecao
	mov rdx, 0		; ler, nao criar arquivo
	syscall

	; mmap
	mov r8, rax		; descritor do arquivo
	mov rax, 9		; syscall mmap
	mov rdi, 0		; os escolhe
	mov rsi, 4096		; tamanho da page = 4k
	mov rdx, PROT_READ	; pode ser lida
	mov r10, MAP_PRIVATE	; privada
	mov r9, 0		; offset = 0
	syscall

	mov rdi, rax		; argumento
	call parse_uint		; passa para num

	mov rdi, rax
	call find_prime

	; exit
	mov rax, 60
	syscall

