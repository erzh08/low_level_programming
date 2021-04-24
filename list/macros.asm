%define cat_count 42	; defines
%define a mov rax,
%define b rbx
%macro test 3		; macro
	dq %1
	dq %2
	dq %3
%endmacro
BITS 64			;
%define x 5

%if x == 10		; ifs
mov rax, 100

%elif x == 15
mov rax, 115

%elif x == 200
mov rax, 1

%else
mov rax, 0
%endif

%ifdef flag		; IF DEFined
hellostring db 'hello', 0
%endif

%macro pushr 1
%ifidn	%1, rflags	; IF IDeNtical
pushf
%else
push %1
%endif
%endmacro

; %error can warn about more errors before stopping processing
; %fatal would stop completely the assembly
%macro print 1
	%ifid %1		; IF IDentifier	
		mov rdi, %1
		call print_string
	%else
		%ifnum %1	; IF NUMber
			mov rdi, %1
			call print_uint
		%else
			%error "String literals not supported yet"
		%endif
	%endif
%endmacro

; inicio do programa
mov rax, cat_count
a b
test 123, 456, 789
pushr rflags
