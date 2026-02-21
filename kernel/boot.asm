[org 0x7c00]
    KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string

    call switch_to_pm

    jmp $

%include "../functions/print_string.asm"
%include "../protected_mode/gdt.asm"
%include "../functions/disk_load.asm"


[bits 16]
; switch to protected mode
switch_to_pm:
    mov bx, MSG_PRE_JUMP
    call print_string

    cli  ; switch off interputs
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 0x1                ; To make the switch to protected mode , we set
    mov cr0, eax               ; the first bit of CR0 , a control register

    jmp CODE_SEG:init_pm ; Jump to new 32 bit segment which will flush CPU cache as well

[bits 32]
; init registers and the stack once in PM
%include "../protected_mode/print.asm"
init_pm:

    mov ax, DATA_SEG    ; Now in PM , our old segments are meaningless ,
    mov ds , ax         ; so we point our segment registers to the
    mov ss , ax         ; data selector we defined in our GDT
    mov es , ax
    mov fs , ax
    mov gs , ax

    mov ebp, 0x90000     ; Set stack position to top of free space
    mov esp, ebp

    mov ebx, MSG_PROT_MODE
    call print_string_pm

    jmp $

; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16 - bit Real Mode" , 0
MSG_PRE_JUMP db "Jumping to protected mode..." , 0
MSG_PROT_MODE db "Successfully landed in 32 - bit Protected Mode" , 0
MSG_LOAD_KERNEL db "Loading kernel into memory." , 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

times 256 dw 0x0
times 256 dw 0x0
