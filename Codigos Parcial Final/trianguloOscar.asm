org 100h


SECTION .text
main:

    call modoVideo
    call setup
    call dibujarTriangulo

    int 20h

dibujarTriangulo:
    CALL dibujarLinea
    CALL siguienteLinea
    dec si
    CMP DX, 250
    JB dibujarTriangulo
    ret

setup:
    mov cx, 100
    mov dx, 100
    mov si, 250
    ret

modoVideo:
    MOV AH, 00h
    MOV AL, 12h
    INT 10h
    RET

encenderPixel:
    MOV AH, 0Ch       
    MOV AL, 02h       
    MOV BH, 00h    
    INT 10h
    RET

dibujarLinea:
    CALL encenderPixel
    INC CX
    CMP CX, si
    JBE dibujarLinea
    RET

siguienteLinea:
    MOV CX, 100
    ADD DX, 1
    RET