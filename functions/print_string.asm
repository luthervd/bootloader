print_string:
    pusha
    mov ah, 0X0e

read_char:
    mov al, [bx]
    cmp al, 0 
    jne print_character
    jmp new_line

new_line:
    mov al, 0xa
    int 0x10
    mov al, 0x0d
    int 0x10
    popa
    ret

print_character:
    int 0x10
    add bx, 1
    jmp read_char