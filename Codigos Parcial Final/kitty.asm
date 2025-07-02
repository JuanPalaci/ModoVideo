ORG 100h

SECTION .text

XOR AX, AX
XOR BX, BX
XOR CX, CX
XOR DX, DX

main:
    CALL IrAModoVideo
    CALL kitty

int 20h

IrAModoVideo:
    MOV AH,00h
    MOV AL, 12h   ; 640x480 px y 16 colores
    INT 10h
    mov SI, 100d ; columnas eje x
    MOV DI, 150d ; filas eje y
    RET

kitty:
    CALL DibujarCuadroPrincipal
    CALL DibujarOjos
    CALL DibujarNariz
    CALL DibujarOrejas
    CALL DibujarBigotes
    RET


; esta es la cara
DibujarCuadroPrincipal:  ; este es un cuadro de 500x450
    ; Dibujar un pixel
    MOV AH, 0CH
    MOV AL, 0Fh ;color blanco
    MOV BH, 0d ; pagina 0
    MOV CX, SI ; columna
    MOV DX, DI ; fila
    INT 10h
    ;incrementar la columna para una linea
    INC SI
    ; comparar si se llego al final de la fila
    CMP SI,500d
    JNE DibujarCuadroPrincipal
    ;si se termino de dibujar cambiamos de fila
    INC DI
    ;reinciar SI para que retroceda y vuevla a la posicion incial
    MOV SI,100d
    CMP DI, 450d ; si llego al final
    JNE DibujarCuadroPrincipal
    RET

; Ojos de la Kitty
DibujarOjos:
    ; Ojo izquierdo
    MOV DI, 220d       ; Y inicial
OjoIzq_Fila:
    MOV SI, 250d       ; X inicial
OjoIzq_Col:
    MOV AH, 0Ch
    MOV AL, 00h       ; color negro
    MOV BH, 00h
    MOV CX, SI
    MOV DX, DI
    INT 10h
    INC SI
    CMP SI, 280d       ; 30 píxeles de ancho, ajustar x
    JL OjoIzq_Col
    INC DI
    CMP DI, 250d       ; 30 píxeles de alto, ajustar y
    JL OjoIzq_Fila

    ; Ojo derecho
    MOV DI, 220d       ; Y inicial
OjoDer_Fila:
    MOV SI, 330d      ; X inicial
OjoDer_Col:
    MOV AH, 0Ch
    MOV AL, 00h       ; color negro
    MOV BH, 00h
    MOV CX, SI
    MOV DX, DI
    INT 10h
    INC SI
    CMP SI, 360d       ; 30 píxeles de ancho, ajustar x
    JL OjoDer_Col
    INC DI
    CMP DI, 250d       ; 30 de alto, ajustar y
    JL OjoDer_Fila
    RET

DibujarNariz:
    MOV DX, 300d  ; Y incial
    MOV SI, 50d  ; tamaño inicial de semi-base
SiguienteFila:
    MOV CX,300d ;centro del triangulo
    SUB CX,SI  ;X inicial = centro -SI
    MOV BP,0   ; contador de píxeles por fila
PintarFila:
    MOV AH, 0Ch
    MOV AL, 00h        ; color negro
    MOV BH, 00h
    INT 10h
    INC CX
    INC BP
    MOV AX, SI
    SHL AX, 1          ; AX = SI * 2
    INC AX             ; AX = 2*SI + 1
    CMP BP, AX
    JL PintarFila
    INC DX             ; siguiente fila (Y)
    DEC SI             ; disminuir fila para triangulo invertido
    CMP SI, 0         ; vemos si llego al final
    JGE SiguienteFila ;si no llego, seguimos dibujando
    RET

DibujarOrejas:
    ;oreja izquierda
    MOV DX, 50d ; Y
    MOV SI, 1 ; ancho
SiguienteLineaTriangulo:
    MOV CX, 100d    ; X inicial 
    MOV BP, 0       ; Contador de píxeles por línea
PintarLinea:
    MOV AH, 0Ch
    MOV AL, 0Fh     ; Color verde 
    MOV BH, 0
    INT 10h
    INC CX
    INC BP
    CMP BP, SI
    JL PintarLinea

    INC DX          ; siguiente fila
    INC SI          ; línea más ancha
    CMP DX, 150d    ; altura del triángulo
    JL SiguienteLineaTriangulo
    
    ;oreja derecha
    MOV DX, 50d ; Y
    MOV SI, 1 ; ancho
SiguienteLineaTrianguloDer:
    MOV CX, 500d    ; X inicial 
    SUB CX, SI       ; para que pinte de derecha a izquierda
    MOV BP, 0       ; Contador de píxeles por línea
PintarLineaDer:
    MOV AH, 0Ch
    MOV AL, 0Fh     ; Color blanco 
    MOV BH, 0
    INT 10h
    INC CX
    INC BP
    CMP BP, SI
    JL PintarLineaDer

    INC DX          ; siguiente fila
    INC SI          ; línea más ancha
    CMP DX, 150d    ; altura del triángulo
    JL SiguienteLineaTrianguloDer
    RET

DibujarBigotes:
    ;Bigote izquierdo arriba
    MOV DI, 270d       ; Y inicial
BigIzq_Fila:
    MOV SI, 50d       ; X inicial
BigIzq_Col:
    MOV AH, 0Ch
    MOV AL, 0Eh       ; color amarillo
    MOV BH, 00h
    MOV CX, SI
    MOV DX, DI
    INT 10h
    INC SI
    CMP SI, 180d       ; 10 píxeles de ancho, ajustar x
    JL BigIzq_Col
    INC DI
    CMP DI, 280d       ; 10 píxeles de alto, ajustar y
    JL BigIzq_Fila
    ;Bigote izquierdo abajo
    MOV DI, 300d       ; Y inicial
BigIzq2_Fila:
    MOV SI, 50d       ; X inicial
BigIzq2_Col:
    MOV AH, 0Ch
    MOV AL, 0Eh       ; color amarillo
    MOV BH, 00h
    MOV CX, SI
    MOV DX, DI
    INT 10h
    INC SI
    CMP SI, 180d       ; 10 píxeles de ancho, ajustar x
    JL BigIzq2_Col
    INC DI
    CMP DI, 310d       ; 10 píxeles de alto, ajustar y
    JL BigIzq2_Fila
    ;bigote derecho abajo
    MOV DI, 300d       ; Y inicial
BigIzq3_Fila:
    MOV SI, 450d       ; X inicial
BigIzq3_Col:
    MOV AH, 0Ch
    MOV AL, 0Eh       ; color amarillo
    MOV BH, 00h
    MOV CX, SI
    MOV DX, DI
    INT 10h
    INC SI
    CMP SI, 550d       ; 10 píxeles de ancho, ajustar x
    JL BigIzq3_Col
    INC DI
    CMP DI, 310d       ; 10 píxeles de alto, ajustar y
    JL BigIzq3_Fila
    ;bigote derecho arriba
    MOV DI, 270d       ; Y inicial
BigIzq4_Fila:
    MOV SI, 450d       ; X inicial
BigIzq4_Col:
    MOV AH, 0Ch
    MOV AL, 0Eh       ; color amarillo
    MOV BH, 00h
    MOV CX, SI
    MOV DX, DI
    INT 10h
    INC SI
    CMP SI, 550d       ; 10 píxeles de ancho, ajustar x
    JL BigIzq4_Col
    INC DI
    CMP DI, 280d       ; 10 píxeles de alto, ajustar y
    JL BigIzq4_Fila
    RET