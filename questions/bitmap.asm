global _start

section .data
newline: db 10
is_prime: dd 0b00100000000000000

section .text

%assign limit 15
%assign n 3
%rep limit
	%assign current 1
	%assign i 1
	%rep n/2
		%assign i i+1
		%if n % i = 0
			%assign current 0
			%exitrep
		%endif
	%endrep
	and is_prime, (current << 16-n)
	%assign n n+1
%endrep

print_newline:
	mov rax, 1			;write
	mov rdi, 1			;stdout
	mov rsi, newline		;char
	mov rdx, 1			;size
	syscall
ret

_start:
	mov rsi, is_prime
	mov rax, 1
	mov rdi, 1
	mov rdx, 2
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

