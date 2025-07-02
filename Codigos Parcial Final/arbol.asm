org 100h          ; Dirección de inicio para programas COM en modo real (DOS)

section .text     ; Sección de código

; Limpieza de registros para asegurar que no tengan basura
XOR AX, AX
XOR BX, BX
XOR CX, CX
XOR DX, DX

main:
    CALL IrAModoVideo      ; Cambiar a modo gráfico 640x480, 16 colores (modo 12h)

    ; Primer triángulo (más pequeño, más arriba)
    MOV DX, 50d            ; Coordenada Y inicial (fila)
    MOV CX, 420d           ; Coordenada X del centro del triángulo
    MOV SI, 15d            ; Altura del triángulo (número de filas)
    CALL DibujarTrianguloEquilatero

    ; Segundo triángulo (mediano, más abajo)
    MOV DX, 65d
    MOV CX, 420d
    MOV SI, 20d
    CALL DibujarTrianguloEquilatero

    ; Tercer triángulo (más grande, más abajo aún)
    MOV DX, 85d
    MOV CX, 420d
    MOV SI, 25d
    CALL DibujarTrianguloEquilatero

    ; Tronco del árbol (cuadrado marrón)
    CALL DibujarTronco

    ; Esperar una tecla para finalizar el programa
    MOV AH, 00h
    INT 16h
    RET                   ; Salir del programa (regresa al DOS)

int 20h                   ; Fin del programa (alternativa para DOS)

; -----------------------
; Subrutina para activar modo gráfico 12h
; -----------------------
IrAModoVideo:
    MOV AH, 00h           ; Función 00h: cambiar modo de video
    MOV AL, 12h           ; AL = 12h → modo gráfico 640x480, 16 colores
    INT 10h               ; Interrupción BIOS para video
    RET

; -----------------------
; Subrutina para dibujar un triángulo equilátero
; Entrada:
;   DX = Y inicial
;   CX = centro en X
;   SI = altura
; -----------------------
DibujarTrianguloEquilatero:
    PUSH CX               ; Guarda el centro original de X en la pila
    MOV BP, 0             ; BP = fila actual (desde 0 hasta altura - 1)

DTE_SiguienteFila:
    POP AX                ; Recupera el centro X en AX
    PUSH AX               ; Lo vuelve a guardar para la siguiente fila

    SUB AX, BP            ; Calcula el X inicial: centro - fila actual
    MOV BX, AX            ; BX = coordenada X inicial para esta fila
    MOV DI, 0             ; Contador de píxeles en la fila actual

DTE_PintarPixel:
    MOV AH, 0Ch           ; Función para escribir pixel (modo gráfico)
    MOV AL, 02h           ; Color verde (02h)
    MOV BH, 00h           ; Página 0
    MOV CX, BX            ; CX = coordenada X actual
    INT 10h               ; Dibuja pixel en (CX, DX)

    INC BX                ; Avanza una posición en X
    INC DI                ; Incrementa cantidad de píxeles dibujados

    MOV AX, BP
    SHL AX, 1             ; AX = BP * 2
    INC AX                ; AX = 2 * fila + 1 (ancho total de la fila)

    CMP DI, AX            ; ¿Ya se dibujaron todos los píxeles?
    JL DTE_PintarPixel    ; Si no, sigue dibujando

    INC DX                ; Baja una fila (Y)
    INC BP                ; Avanza a la siguiente fila lógica
    CMP BP, SI            ; ¿Ya se dibujaron todas las filas?
    JL DTE_SiguienteFila  ; Si no, dibujar siguiente fila

    POP CX                ; Limpia el último valor de la pila (ya no necesario)
    RET

; -----------------------
; Subrutina para dibujar el tronco del árbol
; Dibuja un rectángulo marrón de 10 píxeles de ancho por 10 de alto
; -----------------------
DibujarTronco:
    MOV DX, 110d          ; Fila inicial donde comienza el tronco (Y)
FilaTronco:
    MOV CX, 160d          ; Columna inicial (X) del tronco (izquierda del rectángulo)
    MOV SI, 0             ; Contador para ancho

ColumnaTronco:
    MOV AH, 0Ch           ; Función de escribir pixel
    MOV AL, 06h           ; Color marrón (06h)
    MOV BH, 00h
    INT 10h               ; Dibuja un pixel en (CX, DX)

    INC CX                ; Siguiente columna
    INC SI                ; Contador de ancho
    CMP SI, 10            ; ¿Ya se dibujaron 10 columnas?
    JL ColumnaTronco      ; Si no, seguir dibujando

    INC DX                ; Siguiente fila
    CMP DX, 120d          ; ¿Ya se hicieron 10 filas?
    JL FilaTronco         ; Si no, seguir dibujando filas
    RET
