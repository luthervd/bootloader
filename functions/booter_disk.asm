[org 0x7c00]
    mov [BOOT_DRIVE] , dl
    mov bp, 0x8000 
    mov sp, bp    
    mov bx, 0x9000 
    mov dh, 5     
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000] 
    call print_hex    
                  
    mov dx, [0x9000 + 512] 
    call print_hex            
    jmp $

%include "print_string.asm" ; Re - use our print_string function
%include "print_hex.asm" ; Re - use our print_hex function
%include "disk_load.asm"

; Include our new disk_load function

; Global variables
BOOT_DRIVE : db 0
; Bootsector padding
times 510 -($-$$) db 0
dw 0xaa55

; We know that BIOS will load only the first 512 - byte sector from the disk ,; so if we purposely add a few more sectors to our code by repeating some
; familiar numbers , we can prove to ourselfs that we actually loaded those
; additional two sectors from the disk we booted from.
times 256 dw 0xdada
times 256 dw 0xface