ORG 100H

SECTION .text
    ; LIMPIAR LOS REGISTROS
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    CALL iniciarModoVideo
    MOV DX, 90d
    MOV CX, 70d   ;este parte de la coordenada (70,90) (fila,columna)
    CALL imprimirCuadro

imprimirCuadro:  ; esta es la  altura que es 50
    CALL imprimirLinea
    INC DX
    CMP DX, 140d
    JL imprimirCuadro
    RET   
imprimirLinea:  ;esta es el ancho que es 100
    CALL encenderPixel
    INC CX
    CMP CX, 170d
    JL imprimirLinea
    MOV CX, 70d  ; vuelve para que pinte desde aqui
    RET


iniciarModoVideo:
    MOV AH, 00h
    MOV AL, 12h
    INT 10h
    RET

;@param
; DX FILA
; CX COLUMNA
encenderPixel:
    MOV AH, 0Ch
    MOV AL, 04h
    MOV BH, 00h
    INT 10h
    RET



; para un trianuglo isoceles
;1 -  vertice
; 2- inc a un lado
; 3- regreso a vertice
; 4- decremento a un lado