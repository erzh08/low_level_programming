AC = nasm
AF = -felf64
PROG = dict

all:$(PROG)

$(PROG):main.o lib.o dict.o
	ld -o $(PROG) main.o lib.o dict.o

main.o:main.asm
	$(AC) $(AF) -o main.o main.asm

dict.o:dict.asm
	$(AC) $(AF) -o dict.o dict.asm

lib.o:lib.asm
	$(AC) $(AF) -o lib.o lib.asm

clean:
	rm -f lib.o main.o dict.o dict
