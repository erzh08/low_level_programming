lgdt cs:[_gdtr]
mov eax, cr0		; !! instrucao privilegiada
or al, 1		; bit responsavel pelo modo protegido
mov cr0, eax		; !! instrucao privilegiada

jmp (0x1 << 3):start32	; atribui o primeiro seletor de segmento para cs

align 16
_gdtr:			; armazena o indice da ultima entrada da GDT + endereco da GDT
	dw 47
	dq _gdt

align 16
_gdt:
	; descritor nulo (deve estar presente em qualquer GDT)
	dd 0x00, 0x00
	; descritor de codigo x32: difere pelo bit de execucao
	db 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x9A, 0xCF, 0x00
	; descritor de dados x32: execucao desativada (0x92)
	db 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x92, 0xCF, 0x00
	;  tam   tam   base  base  base  util util|tam base
;ou
;descritor de codigo: indica segmento legivel e escritivel, anel 0
;dw 0xFFFF	limit low: segment limit; each segment is 64K
;db 0x00	base low (starting address) of segment; code selector can access every byte between 0x00 and 0xFFFF
;db 0x00	base middle and base low is 3 bytes (bit 0-23 of base address); provavelmente falta outro 0x00
;db 0x9A	access byte: bits 40-47 (change bits 40 and 47 when using vitual memory)
;db 0xCF	granularity bit: bits 48-55
;db 0x00	base high (bits 24-32 of the base address)
;
;descritor de dados: igual o anterior, mas com bit 43 diferente
;dw 0xFFFF	limit low: segment limit; each segment is 64K
;db 0x00	base low (starting address) of segment; code selector can access every byte between 0x00 and 0xFFFF
;db 0x00	base middle and base low is 3 bytes (bit 0-23 of base address); provavelmente falta outro 0x00
;db 0x92	access byte: bits 40-47 (change bits 40 and 47 when using vitual memory)
;db 0xCF	granularity bit: bits 48-55
;db 0x00	base high (bits 24-32 of the base address)

