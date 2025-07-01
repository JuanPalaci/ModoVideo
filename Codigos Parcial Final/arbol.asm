org 100h


section .text

XOR AX, AX
XOR BX, BX
XOR CX, CX
XOR DX, DX

main:
    CALL IrAModoVideo
    ;primer triangulo
    ; se necesitan los parametros
    MOV DX, 50d      ; Y inicial
    MOV CX, 420d     ; centro X
    MOV SI, 15d      ; altura
    CALL DibujarTrianguloEquilatero

    ; Segundo triángulo (más abajo)
    MOV DX, 65d   ; eje Y en este caso incia cuando termina el otro triangulo
    MOV CX, 420d  ; centro en X
    MOV SI, 20d  ; altura
    CALL DibujarTrianguloEquilatero
    
    ; Tercer triángulo (más grande)
    MOV DX, 85d  ; eje Y
    MOV CX, 420d ; Centro X
    MOV SI, 25d  ;altura
    CALL DibujarTrianguloEquilatero

    ; Tronco
    CALL DibujarTronco

    ; Esperar tecla para terminar
    MOV AH, 00h
    INT 16h
    RET

int 20h

IrAModoVideo:
    MOV AH,00h
    MOV AL, 12h   ; 640x480 px y 16 colores
    INT 10h
    RET


DibujarTrianguloEquilatero:
    PUSH CX         ; guarda centro original
    MOV BP, 0       ; fila actual
DTE_SiguienteFila:
    POP AX          ; recupera centro original en AX
    PUSH AX         ; volver a guardar para siguiente fila

    SUB AX, BP      ; X inicial = centro - fila
    MOV BX, AX      ; X para esta fila
    MOV DI, 0       ; contador de píxeles

DTE_PintarPixel:
    MOV AH, 0Ch
    MOV AL, 02h     ; color verde
    MOV BH, 00h
    MOV CX, BX      ; CX = X
    INT 10h

    INC BX
    INC DI
    MOV AX, BP
    SHL AX, 1
    INC AX
    CMP DI, AX
    JL DTE_PintarPixel

    INC DX
    INC BP
    CMP BP, SI
    JL DTE_SiguienteFila

    POP CX          ; limpia pila final
    RET



DibujarTronco:   ;este es un cuadrado de toda la vida
    MOV DX, 110d   ; empieza debajo del último triángulo
FilaTronco:
    MOV CX, 160d   ; X inicial
    MOV SI, 0
ColumnaTronco:
    MOV AH, 0Ch
    MOV AL, 06h    ; color marrón
    MOV BH, 00h
    INT 10h
    INC CX
    INC SI
    CMP SI, 10
    JL ColumnaTronco

    INC DX
    CMP DX, 120d   ; 20 filas
    JL FilaTronco
    RET
