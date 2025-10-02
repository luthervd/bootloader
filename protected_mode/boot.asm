[org 0x7c00]

    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string

    jmp $

%include "../functions/print_string.asm"

; Global variables
MSG_REAL_MODE db "Started in 16 - bit Real Mode", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55