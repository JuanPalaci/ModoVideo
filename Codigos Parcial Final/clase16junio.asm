org 100h
section .data
    nombre db "Juan" 
    color db 20h,31h,42h,43h,40h,55h,66h,77h

section .text
    mov bp, nombre
    CALL establecerModoTexto
    mov dl, 35d

print:
    CALL posCursor
    mov al, [bp+Si]
    mov bl,[color+si]
    CALL escribir
    inc dl
    inc si
    cmp si, 4d
    je fin
    jmp print 

fin:
    int 20h            ; Terminar el programa

establecerModoTexto:
    mov ah, 00h
    mov al, 03h
    int 10h
    ret

escribir:
    mov ah, 09h
    mov bh, 00h
    mov cx, 01h
    int 10h
    ret
 posCursor:
    mov ah, 02h
    mov bh, 00h
    mov dh, 0Ah       ; Fila 10
    int 10h
    ret