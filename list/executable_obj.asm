global somewhere
global func

section .data
somewhere: dq 999
private: dq 333

section .text
func:
	mov rax, somewhere
   ret
