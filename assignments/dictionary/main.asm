global _start
extern find_word
extern read_word
extern print_newline
extern print_string

section .bss
usr_msg: resb 255

section .text
%include 'colon.inc'

section .data
read_sh: db 'Write keyword: ',0
read_msg: db 'Keyword read succesfully', 0
rerr_msg: db 'Oops, there was an error when trying to read', 0
err_msg: db 'An error ocurred', 0
succ_msg: db 'Keyword found on the dict:', 0
fail_msg: db 'Keyword not found', 0
%include 'words.inc'

section .text
_start:
	mov rdi, read_sh
	call print_string

	mov rdi, usr_msg
	mov rsi, 255
	call read_word

	cmp rax, 0
	je .read_err

	mov rdi, rax				; user given str
	mov rsi, last_word			; last word addr
	call find_word

	test rax, rax
	jz .not_found
	push rax

	mov rdi, succ_msg
	call print_string
	call print_newline
	
	pop rdi
	call print_string
	call print_newline
	xor rdi, rdi
.end:
	mov rax, 60
	syscall

.read_err:
	mov rdi, rerr_msg
	call print_string
	call print_newline
	mov rdi, 1
	jmp .end

.not_found:
	mov rdi, fail_msg
	call print_string
	call print_newline
	mov rdi, 1
	jmp .end

