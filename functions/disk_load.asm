disk_load:
    push dx
    mov ah, 0x02   ; bios read sector
    mov al, dh     ; read number of sectors as specified in DH
    mov ch, 0x00   ; cylinder 0
    mov dh, 0x00   ; Head 0
    mov cl, 0x02   ; read from second sector 512kb sectors so after boot sector
    int 0x13       ; Bios interupt

    jc disk_error  ; jump if carry flag set 

    pop dx         ; restore dx from stack
    cmp dh, al     ; check if sectors requested (DH) equals sectors read (al)
    jne disk_error ; Jump if not equal
    ret 

disk_error:
    mov bx , DISK_ERROR_MSG
    call print_string
    jmp $ 

DISK_ERROR_MSG db "Disk read error !", 0