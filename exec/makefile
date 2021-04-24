PROG = check_fib

all: assemble link run clear

assemble:
	nasm -f elf64 ./../$(PROG).asm -o ./../obj/$(PROG).o

link: ./../obj/$(PROG).o
	ld ./../obj/$(PROG).o -o $(PROG)

run: $(PROG)
	./$(PROG)

clear:
	rm ./../obj/$(PROG).o $(PROG)
