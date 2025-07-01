org 100h

section .data
    color db 20h, 31h, 42h, 53h, 41h

section .bss
    ; nada

section .text
    ; — Inicialización —
    xor si, si             ; índice a color/posición = 0
    call establecerModoTexto
    mov dl, 35d            ; columna inicial = 35

print:
    ; — Posicionar cursor y leer tecla —
    call posCursor
    mov ah, 00h
    int 16h                ; al = carácter; ah = scancode

    cmp al, 08h            ; ¿Backspace?
    je .backspace

    ; — Impresión normal —
    mov ah, 09h            ; Write Char+Attr
    mov bh, 00h            ; página de texto
    mov bl, [color]   ; atributo de color
    mov cx, 1
    int 10h

    inc dl                 ; siguiente columna
    inc si                 ; siguiente color/índice
    cmp al,13              ; comparar con Enter y saltar si es Enter 
    je fin                 ; si es Enter, terminar
    jmp print

.backspace:
    cmp si, 0              ; ¿estamos en el inicio?
    je print               ; nada que borrar
    dec dl                 ; retrocede columna
    dec si                 ; retrocede índice

    call posCursor
    mov ah, 09h            ; sobreescribir con espacio
    mov bh, 00h
    mov al, ' '            ; carácter espacio
    mov bl, 00h   ; mismo atributo que usarías
    mov cx, 1
    int 10h

    jmp print

fin:
    int 20h

; — Rutinas de soporte —

establecerModoTexto:
    mov ah, 00h
    mov al, 03h
    int 10h
    ret

posCursor:
    mov ah, 02h
    mov bh, 00h
    mov dh, 0Ah            ; fila fija 10 (0Ah)
    int 10h
    ret