%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .data
; este e o nome do arquivo, null-terminated
fname: db 'test.txt', 0

section .text
global _start

string_length:
	xor rax, rax
.loop:
	cmp byte [rdi+rax], 0
	je .end
	inc rax
	jmp .loop
.end:
    ret

print_string:
	push rdi
	call string_length
	pop rsi
	mov rdx, rax
	mov rax, 1
	mov rdi, 1
	syscall
    ret

_start:
	; chama open
	mov rax, 2	; syscall 'open'
	mov rdi, fname
	mov rsi, O_RDONLY	; abre somente para leitura
	mov rdx, 0		; arquivo nao esta sendo criado
	syscall

	; mmap
	mov r8, rax		; armazena descritor do arquivo aberto,
				; quarto arg de mmap
	mov rax, 9		; syscall 'mmap'
	mov rdi, 0		; destino do mapeamento escolhido pelo OS
	mov rsi, 4096		; tamanho da pagina
	mov rdx, PROT_READ	; nova regiao de memoria marcada como somente leitura
	mov r10, MAP_PRIVATE	; paginas privadas (nao compartilhadas)
	mov r9, 0		; offset em text.txt
	syscall			; agora rax aponta para o local mapeado

	mov rdi, rax
	call print_string

	mov rax, 60
	xor rdi, rdi
	syscall
