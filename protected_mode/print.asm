[bits 32]
;constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_string_pm: 
    pusha
    mov edx, VIDEO_MEMORY ; set edx to start of vid VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx] ; Store char at ebx in al
    mov ah, WHITE_ON_BLACK ; set colour

    cmp al, 0 ; check for end of print_string_pm
    je done

    move [edx], ax ; Store char and attributes at current character cell

    add ebx, 1 ; next char
    add edx, 2 ; next char cell

    jmp print_string_pm_loop ; loop to next char

print_string_pm_done:
    popa
    ret  ;return from the function