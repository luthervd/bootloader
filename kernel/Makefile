# Build the kernel binary
kernel.bin : kernel_entry.o kernel.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

# Build the kernel object file
kernel.o : kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o

# Build the kernel entry object file .
kernel_entry.o : kernel_entry.asm
	nasm kernel_entry.asm -f elf32 -o kernel_entry.o