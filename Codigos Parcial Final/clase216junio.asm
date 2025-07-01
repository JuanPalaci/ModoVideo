org 100h
section .data
    ;name db "Carlo"
    color db 20h, 31h, 42h, 53h, 41h
section .text

    ;mov bp, name;
    call establecerModoTexto;
    mov dl, 35d
print: 
    call posCursor
    call escribirTecla
    mov bl, [color]
    call escribir
    inc dl
    inc si
    cmp al,13 ; Comprobar si la tecla es Enter
    je fin
    jmp print
fin:
    int 20h
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
    mov dh, 0Ah
    int 10h
    ret
escribirTecla:
    MOV AH, 00h
    int 16h
    ret