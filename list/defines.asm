; %define posterga a substituicao de macros
	; funfa com redefinicoes
; %xdefine forca a substituicao antes
; %assign forca a substituicao e tenta realizar aritmetica
	; e laca um erro se o processamento nao for um numero
%define i 1
%define d i * 3
%xdefine xd i * 3
%assign a i * 3

mov rax, d
mov rax, xd
mov rax, a

%define i 100
mov rax, d
mov rax, xd
mov rax, a
