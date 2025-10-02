; GDT
gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

gdt_code: ; code segment sector 
    dw 0xffff ; limit (bits 0-15)
    dw 0x0 ;  Base (bits 0 - 15)
    db 0x0 ;  Base (bits 16- 23)
    db 10011010b ; 1st flags ( present )1 ( privilege )00 ( descriptor type )1 then type flags ( code )1 ( conforming )0 ( readable )1 ( accessed )0
    db 11001111b ; 2nd flags ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 then Limit (bits 16 - 19)
    db 0x0 ; Base (bits 24-31)

gdt_data: ; the data segment descriptor
    dw 0xffff ; limit (bits 0-15)
    dw 0x0 ;  Base (bits 0 - 15)
    db 0x0 ;  Base (bits 16- 23)
    db 10010010b ; 1st flags ( present )1 ( privilege )00 ( descriptor type )1 then type flags ( code )0 ( expand down )0 ( writable )1 ( accessed )0
    db 11001111b ; 2nd flags ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 then Limit (bits 16 - 19)
    db 0x0 ; Base (bits 24-31)

gdt_end: ;Enable assembler to calc the size of the GDT

; GDT descriptor

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; soze of the GDT, always less one
    dd gdt_start ; Start address of our GDT

; Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0 x10 in PM , the CPU knows that we mean it to use the
; segment described at offset 0 x10 ( i.e. 16 bytes ) in our GDT , which in our
; case is the DATA segment (0 x0 -> NULL ; 0x08 -> CODE ; 0 x10 -> DATA )
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
