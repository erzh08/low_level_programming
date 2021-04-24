align 16	; garante que o proximo comando ou elemento de dado
		; seja armazenado comecando em um endereco divisivel
		; por 16 (mesmo que seja necessario pular alguns bytes)

; os dados a seguir serao copiados para o GDTR por meio da instrucao LGDTR
GDTR64:				; Global Descriptors Table Register
	dw gdtr_end - gdt64 - 1	; limite da GDT (tamanho - 1)
	dq 0x0000000000001000	; endereco linear da GDT

; estrutura copiada para 0x0000000000001000
gdt64:
SYS64_NULL_SELL equ $-gdt64	; segmento nulo
	dq 0x0000000000000000
; segmento de codigo, leitura/exec, nonconforming
SYS64_CODE_SEL equ $-gdt64
	dq 0x0020980000000000	;0x00209A0000000000
; segmento de dados, leitura/escrita, expand down (expansao para baixo)
SYS64_DATA_SEL equ $-gtd64
	dq 0x0000900000000000	;0x0020920000000000

gdt64_end:

; o sinal $ representa o endereco de memoria atual, portanto
; $-gdt64 significa um offset a partir do rotulo 'gdt64' em bytes
