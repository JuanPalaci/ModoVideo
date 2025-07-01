ORG 100h

SECTION .text
main:
    CALL iniciarModoVideo
    ; Inicializamos la posición base del triángulo
    MOV DX, 100       ; Y inicial (fila)
    MOV SI, 1         ; Ancho de la línea (base creciente)

dibujarTriangulo:
    MOV CX, 100       ; X inicial (columna)
    MOV DI, 0         ; Contador de píxeles por línea

dibujarLinea:
    CALL encenderPixel
    INC CX
    INC DI
    CMP DI, SI
    JL dibujarLinea

    ; Preparar la siguiente línea
    INC DX            ; Bajar una fila
    INC SI            ; Aumentar el ancho de la base
    CMP DX, 250       ; Altura del triángulo (de 100 a 150)
    JL dibujarTriangulo

    INT 20h           ; Terminar el programa

iniciarModoVideo:
    MOV AH, 00h
    MOV AL, 12h
    INT 10h
    RET

encenderPixel:
    MOV AH, 0Ch
    MOV AL, 04h       ; Color rojo
    MOV BH, 00h       ; Página
    INT 10h
    RET