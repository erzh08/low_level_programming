exit:
	xor rdi, rdi
	mov rax, 60
	syscall

string_length:  ; rdi = string address
	xor rax, rax
.loop:
	cmp byte[rdi+rax], 0
	je .end
	inc rax
	jmp .loop
.end:
	ret
; rax = string size

print_string:	; rdi = string address
	call string_length
	mov rdx, rax				; size
	mov rax, 1					; syscall = write
	mov rsi, rdi				; string
	mov rdi, 1					; fd = stdout
	syscall
	ret

print_char:		; rdi = char
	push rsp
	dec rsp
	push rdi
	mov rdi, rsp
	push 0
	dec rsp
	call print_string
	add rsp, 8+8+1+1
	pop rsp
	ret

print_newline:
	mov rdi, 0x0A
	jmp print_char

print_uint:		; rdi = (8 bytes)uint
	push r13
	push rsp
	push 0
	mov rax, rdi
	mov rdi, rsp
	dec rdi
	sub rsp, 16
	mov r13, 10
.loop:
	xor rdx, rdx
	div r13						; rax/10: al = quoc., dl = rest
	or dl, 0x30					; 0x04 -> 0x34 (ASCII)
	dec rdi
	mov [rdi], dl
	test rax, rax
	jnz .loop
	call print_string
	add rsp, 24
	pop rsp
	pop r13
	ret

print_int:			; rdi = (8 bytes)int
	test rdi, rdi
	jns print_uint
	push rdi
	mov rdi, 0x2D
	call print_char
	pop rdi
	neg rdi
	jmp print_uint

read_char:
	push rsp
	xor rax, rax				; syscall 'read'
	xor rdi, rdi				; stdin
	dec rsp
	mov rsi, rsp				; buf
	mov rdx, 1
	syscall
	mov al, [rsi]
	inc rsp
	pop rsp
	ret
; rax = (read) char

read_word:			; rdi = buffer, rsi = size
	push r14
	push r13
	push r12
	mov r14, rdi
	xor r13, r13
	mov r12, rsi
.read:
	call read_char
	cmp rax, 0x09				; '\t'
	je .read
	cmp rax, 0x0A				; '\n'
	je .read
	cmp rax, 0x20				; ' '
	je .read
	mov [r14 + r13], rax
	inc r13
	cmp r12, r13
	je .end
	jmp .read
.end:
	call read_char
	pop r12
	cmp rax, 0x0A				; '\n'
	jne .err
	mov rax, r14
	inc r13
	mov byte[rax+r13], 0
	pop r13
	pop r14
	ret
.err:
	xor rax, rax
	pop r13
	pop r14
	ret
; rax = buffer address (if successful) OR 0 (if error)

parse_uint:			; rdi = string buffer
	push r13
	xor rcx, rcx
	xor rax, rax
	mov r13, 10
.loop:
	movzx r9, byte[rdi+rcx]
	cmp r9, 0x30
	jb .end
	cmp r9, 0x39
	ja .end
	and r9, 0x0F
	mul r13
	add rax, r9
	inc rcx
	jmp .loop
.end:
	pop r13
	mov rdx, rcx
	ret
; rax = uint, rdx = char num

parse_int:			; rdi = string buffer
	movzx r10, byte[rdi]
	cmp r10, 0x2B					; '+'
	je .plus
	cmp r10, 0x2D					; '-'
	je .minus
	jmp parse_uint
.plus:
	inc rdi
	call parse_uint
	inc rdx							; dont really know if should inc on this case
	ret
.minus:
	inc rdi
	call parse_uint
	neg rax
	inc rdx
	ret
; rax = int, rdx = char num

string_equals:		; rdi = string_1 buf, rsi = string_2 buf
	xor rcx, rcx
	mov rax, 1
.loop:
	movzx r10, byte[rdi+rcx]
	movzx r9, byte[rsi+rcx]
	cmp r10, r9
	jne .not
	inc rcx
	test r10, r10
	jnz .loop
	ret
.not:
	xor rax, rax
	ret
; rax = 1 (if equal) OR 0 (if different)

string_copy:		; rdi = string_orig buf, rsi = string_dest buf, rdx = size
	push r12
	mov r12, rdx
	xor rcx, rcx
.loop:
	movzx r10, byte[rdi+rcx]
	mov [rsi+rcx], r10
	inc rcx
	cmp rcx, r12
	je .end
	jmp .loop
.end:
	movzx r10, byte[rdi+rcx]
	cmp r10, 0x00
	pop r12
	jne .err
	mov byte[rdi+rcx], 0x00
	mov rax, rsi
	ret
.err:
	xor rax, rax
	ret
