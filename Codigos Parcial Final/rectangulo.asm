org 100h

section .text
    ; Limpieza de registros para asegurar que no tengan basura
XOR AX, AX
XOR BX, BX
XOR CX, CX
XOR DX, DX

main:
    MOV SI, 90d
    MOV DI, 70d
    CALL IrAModoVideo
    CALL DibujarCuadrado


    int 20h


IrAModoVideo:
    MOV AH, 00h           ; Función 00h: cambiar modo de video
    MOV AL, 12h           ; AL = 12h → modo gráfico 640x480, 16 colores
    INT 10h               ; Interrupción BIOS para video
    RET


DibujarCuadrado:    

    EncenderPixel:
    MOV   AH, 0Ch         ; Establecer la función de poner un píxel
    MOV   AL, 04H         ; Color del píxel (rojo)
    MOV   BH, 00H         ; Usar la página de video 0
    MOV   CX, SI         ; Coordenada X del píxel
    MOV   DX, DI         ; Coordenada Y del píxel
    INT   10H             ; Llamar a la interrupción del BIOS para modo gráfico
    JMP DibujarLinea

    DibujarLinea:
    INC SI
    CMP SI, 190d
    JL EncenderPixel
    JMP DibujarColumna

    DibujarColumna:
    INC DI
    MOV SI,90d
    CMP DI,100d
    JL EncenderPixel
    RET