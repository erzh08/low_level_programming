global find_word
extern string_equals
extern string_length

; rdi = (null-terminated str) keyword, rsi = last_word addr
find_word:
	xor rcx, rcx
	mov rcx, rsi

.loop:
	lea rsi, [rcx+8]			; addr + 8(qword) = nth_word

	push rcx
	call string_equals
	pop rcx

	cmp rax, 1
	je .found				; if equal, found

	cmp qword [rcx], 0
	je .not_found				; if addr = 0, then not found

	mov rcx, [rcx]
	jmp .loop				; continue loop

.found:
	call string_length
	mov r9, rax
	lea rax, [rcx+8+1+r9]			; add with 8(to nth_word), 1(from the null char) and keyword size, to get definition addr
	jmp .end

.not_found:
	xor rax, rax
.end:
    ret
