%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .data
fname: db 'input.txt', 0

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
	push rdi		; salva endereco da string
	call string_length
	pop rsi			; passa end. da string para rsi
	mov rdx, rax		; move o retorno (tamanho da string) para
				; rdx, como quantos bytes serao escritos
	mov rax, 1		; syscall 'write'
	mov rdi, 1		; descitor de stdout
	
	syscall

	ret

print_char:
	push rdi
	mov rdi, rsp
	call print_string
	pop rdi

	ret

print_newline:
	mov rdi, 10
	call print_char

	ret

print_uint:
	mov rax, rdi
	mov rdi, rsp
	push 0
	sub rsp, 16
	dec rdi
	mov r8, 10

.loop:
	xor rdx, rdx
	div r8			; divide rax por 10 e salva:
				; al = quoc., dl = resto
	or dl, 0x30		; transforma de numero hex em char dec
	dec rdi
	mov [rdi], dl
	test rax, rax
	jnz .loop

	call print_string

	add rsp, 24		; add 16 bytes iniciais mais 8 bytes (do 0)

	ret

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
	mul r8
	and r9, 0x0f
	add rax, r9
	inc rcx
	jmp .loop

.end:
	mov rdx, rcx
    ret

n_fat:
	mov rax, 1
.loop:
	cmp rdi, 0
	je .end
	mul rdi
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
	mov rdi, 0
	mov rsi, 4096
	mov rdx, PROT_READ
	mov r10, MAP_PRIVATE
	mov r9, 0
	syscall

	; calcula n!
	mov rdi, rax
	call parse_uint
	mov rdi, rax
	call n_fat
	mov rdi, rax

	call print_uint
	call print_newline

	mov rax, 60
	xor rdi, rdi
	syscall
