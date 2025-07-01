org 100h

section .data
    msgOpcUno db '1. Ver figura$'
    msgOpcDos db '2. Salir$'
    msgOpcTres db 'S. regresar$'
    msgFin db 'Fin del programa$'

section .text

XOR AX, AX
XOR BX, BX
XOR CX, CX
XOR DX, DX


main:
    CALL EstablecerModoTexto
    MOV BH,0d  ;pagina 0
    CALL CentrarCursor
    CALL Opcion1
    CALL Opcion2
    CALL Opcion3
    CALL EsperarTecla
    int 20h



EstablecerModoTexto:
    MOV AH, 00h
    MOV AL, 03h ; Modo de texto 80x25
    INT 10h ; Llamada a BIOS para cambiar el modo de texto
    RET ; retornar al flujo principal

CentrarCursor:
    MOV AH,02h ; Función para mover el cursor
    MOV DH, 10d ; Fila 10
    MOV DL, 25d ; Columna 25
    INT 10h ; Llamada a BIOS para mover el cursor
    RET ; retornar al flujo principal


Opcion1:
    MOV AH,09h
    MOV DX,msgOpcUno
    INT 21h
    RET

Opcion2:
    MOV AH,09h
    MOV DX,msgOpcDos
    INT 21h
    RET

Opcion3:
    MOV AH,09h
    MOV DX,msgOpcTres
    INT 21h
    RET


EsperarTecla:
    MOV AH, 00h
    INT 16h        ; Lee una tecla del teclado
    CMP AL, "S"   ; Ver si es para regresar
    JE regresarTexto
    CMP AL, '1'
    JE IrAModoVideo
    CMP AL, '2'
    JE MostrarFin
    
    JMP EsperarTecla  ; si es otra cosa volver a esperar tecla

regresarTexto:
    MOV AH, 00h ; Función para cambiar de página
    MOV AL, 03h ; Página a la que se quiere cambiar
    INT 10h ; Llamada a BIOS para cambiar de página
    JMP main



IrAModoVideo:
    MOV AH,00h
    MOV AL, 12h   ; 640x480 px y 16 colores
    INT 10h
    mov SI, 90d ; columnas
    MOV DI, 70d ; filas
    CALL DibujarCuadro
    CALL DibujarTrianguloEquilatero

EsperarEnVideo:
    MOV AH, 00h
    INT 16h
    CMP AL, 'S'
    JE regresarTexto
    CMP AL, 0Dh
    JE MostrarFin
    JMP EsperarEnVideo

    
DibujarCuadro:
    ; Dibujar un pixel
    MOV AH, 0CH
    MOV AL, 4d ;color del pixel
    MOV BH, 0d ; pagina 0
    MOV CX, SI ; columna
    MOV DX, DI ; fila
    INT 10h
    ;incrementar la columna para una linea
    INC SI
    ; comparar si se llego al final de la fila
    CMP SI,200d
    JNE DibujarCuadro
    ;si se termino de dibujar cambiamos de fila
    INC DI
    ;reinciar SI para que retroceda y vuevla a la posicion incial
    MOV SI,90d
    CMP DI, 170d ; si llego al final
    JNE DibujarCuadro
    RET


MostrarFin:
    ; volver al modo texto 
    MOV AH, 00h
    MOV AL, 03h
    INT 10h
    CALL CambiarPagina ; Llamada a la función para cambiar de página
    MOV BH,1d ; Selecciona la página 1
    CALL CentrarCursor ; Llamada a la función para centrar el cursor
    MOV AH, 09h ; Función para mostrar cadena
    MOV DX, msgFin
    INT 21h ; Llamada a DOS para mostrar la cadena
    CALL EsperarTeclaFin

CambiarPagina:
    MOV AH, 05h ; Función para cambiar de página
    MOV AL, 01h ; Página a la que se quiere cambiar
    INT 10h ; Llamada a BIOS para cambiar de página
    RET ; Retornar al flujo principal

EsperarTeclaFin:
    MOV AH, 00h ; Función para esperar una tecla
    INT 16h ; Llamada a BIOS para esperar una tecla
    CMP AL, 'F'
    JNE EsperarTeclaFin ; Si la tecla no es 'F', esperar otra tecla
    ; Si la tecla es 'F', continuar con el flujo
    RET ; Retornar al flujo principal


DibujarTrianguloRectangulo:
    MOV DX, 70d ; Y
    MOV SI, 1 ; ancho
SiguienteLineaTriangulo:
    MOV CX, 220d    ; X inicial (a la derecha del cuadrado)
    MOV BP, 0       ; Contador de píxeles por línea
PintarLinea:
    MOV AH, 0Ch
    MOV AL, 02h     ; Color verde 
    MOV BH, 0
    INT 10h
    INC CX
    INC BP
    CMP BP, SI
    JL PintarLinea

    INC DX          ; siguiente fila
    INC SI          ; línea más ancha
    CMP DX, 170d    ; altura del triángulo
    JL SiguienteLineaTriangulo
    RET

DibujarTrianguloEquilatero:
    MOV SI,0  ; fila actual
    MOV DX,70d ; Y incial
SiguienteFila:
    MOV CX,320d ;centro del triangulo
    SUB CX,SI  ;X inicial = centro -SI
    MOV BP,0
PintarFila:
    MOV AH, 0Ch
    MOV AL, 02h        ; color verde
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
    INC SI             ; aumentar fila
    CMP SI, 100         ; altura de 20 filas
    JL SiguienteFila
    RET
