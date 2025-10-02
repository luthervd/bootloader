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
; init registers and the stack once in PM

init_pm:

    mov ax, DATA_SEG    ; Now in PM , our old segments are meaningless ,
    mov ds , ax         ; so we point our segment registers to the
    mov ss , ax         ; data selector we defined in our GDT
    mov es , ax
    mov fs , ax
    mov gs , ax

    mov ebp, 0x90000     ; Set stack position to top of free space
    mov esp, ebp

    call BEGIN_PM