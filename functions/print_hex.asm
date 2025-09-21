
print_hex:
    pusha
    mov bx, HEX_OUT
    add bx, 2

    mov cl, dh
    shr cx, 4
    call convert_char
    add bx, 1

    mov cl, dh
    and cx, 00001111b
    call convert_char
    add bx, 1

    mov cl, dl
    shr cx, 4
    call convert_char
    add bx, 1

    mov cl, dl
    and cx, 00001111b
    call convert_char
    add bx, 1

    mov bx, HEX_OUT
    call print_string
    popa 
    ret

convert_char:
    cmp cx, 10
    jge above_ten
    jmp below_ten

above_ten:
    add cx, 87
    mov [bx], cx
    ret

below_ten:
    add cx, 48
    mov [bx], cx
    ret

HEX_OUT: db '0x0000', 0