[org 0x7c00]
    KERNEL_OFFSET equ 0x1000
    CPUID_EXTENSIONS equ 0x80000000 ; returns the maximum extended requests for cpuid
    CPUID_FEATURES equ 0x80000001 ; returns flags containing long mode support among other things
    mov [BOOT_DRIVE], dl
    mov bp, 0x9000
    mov sp, bp
    call switch_to_pm
    jmp $
%include "../protected_mode/gdt.asm"

[bits 16]
; switch to protected mode
switch_to_pm:
    cli  ; switch off interputs
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1                ; To make the switch to protected mode , we set
    mov cr0, eax               ; the first bit of CR0 , a control register
    jmp CODE_SEG:init_pm ; Jump to new 32 bit segment which will flush CPU cache as well

[bits 32]
%include "../protected_mode/print.asm"
%include "../protected_mode/check_cpu.asm"
init_pm:

    mov ax, DATA_SEG    ; Now in PM , our old segments are meaningless ,
    mov ds , ax         ; so we point our segment registers to the
    mov ss , ax         ; data selector we defined in our GDT
    mov es , ax
    mov fs , ax
    mov gs , ax

    mov ebp, 0x90000     ; Set stack position to top of free space
    mov esp, ebp

    call checkCPUID ; check cpuid
    cmp ax, 1
    je .queryLongMode
    jmp .noLongMode

    .queryLongMode:
        mov eax, CPUID_EXTENSIONS
        cpuid
        cmp eax, CPUID_FEATURES
        jb .noLongMode    
    
    .longModeSupported:
        mov ebx, MSG_LONG_MODE_SUPPORTED
        call print_string_pm
        jmp .done

    .noLongMode:
        mov ebx, MSG_NO_LONG_MODE
        call print_string_pm
        jmp .done  

    .done: 
    jmp $

; Global variables
BOOT_DRIVE db 0

MSG_NO_LONG_MODE db "Long Mode NOT Supported" , 0
MSG_LONG_MODE_SUPPORTED db "Long Mode Supported" , 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

times 256 dw 0x0
times 256 dw 0x0
