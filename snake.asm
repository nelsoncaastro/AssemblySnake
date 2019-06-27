org 100h ;Indica en que dirección de memoria comienza el programa.

section .bss ;Sección donde declaramos variables, solo reservamos memoria.

sigpx1: resd 1 ;Variable para almacenar la siguiente posición de X del jugador
sigpy1: resd 1 ;Variable para almacenar la siguiente posición de Y del jugador

auxpx1:	resd 1 ;Variable para almacenar la transición de la posición de X del jugador
auxpy1: resd 1 ;Variable para almacenar la transición de la posición de Y del jugador

orientation: resd 1

section .data ;Sección donde inicializamos variables.

px1: dd  320d ;Variable para almacenar la posición de X actual del jugador
py1: dd	 204d ;Variable para almacenar la posición de X actual del jugador
offset: dd 10d ;Tamaño del cuadro del culebrón

section .text ;Sección del código fuente

global start

start:
    call iniciarModoVideo
	finit
	call drawLimits
	call drawSnake
main:call teclado
	call movimiento

;=======Subrutinas

iniciarModoVideo:
	mov ah, 00h
	mov al, 12h
	int 10h
	ret

sleep_half_s:
	mov cx, 07h
	mov dx, 0a120h
	mov ah, 86h
	int 15h
	ret

clear_screen:
	mov ah, 06h ; Función scroll up
	mov al, 00h ; Clear
	mov bh, 00h ; Atributo
	mov cl, 00h ; Columna inicial
	mov ch, 00h ; Fila inicial
	mov dl, 4fh ; Columna final 
	mov dh, 1dh ; Fila final
	int 10h
	ret

drawLimits:

	mov ecx, 0d
	mov edx, 0d
sigl1:
	call pixelBlanco
	inc ecx
	cmp ecx, 639d
	jne sigl1

	mov ecx, 0d
	mov edx, 408d
sigl2:
	call pixelBlanco
	inc ecx
	cmp ecx, 639d
	jne sigl2

	mov ecx, 0d
	mov edx, 0d
sigl3:
	call pixelBlanco
	inc edx
	cmp edx, 408d
	jne sigl3

	mov ecx, 639d
	mov edx, 0d
sigl4:
	call pixelBlanco
	inc edx
	cmp edx, 408d
	jne sigl4

	ret

drawSnake:
	mov ecx, [px1]
	mov edx, [py1]
	call sigposition
sigd:call pixelBlanco
	inc ecx	
	cmp ecx, [sigpx1]
	jne sigd
	mov ecx, [px1]
	inc edx
	cmp edx, [sigpy1]
	jne sigd
	ret

sigposition:
	fld dword [px1]
	fld dword [offset]
	fadd
	fstp dword [sigpx1]
	fld dword [py1]
	fld dword [offset]
	fadd
	fstp dword [sigpy1]
	ret

addOffsetUp:
	fld dword [py1]
	fld dword [offset]
	fsub
	fstp dword [py1]
	ret

addOffsetDown:
	fld dword [py1]
	fld dword [offset]
	fadd
	fstp dword [py1]
	ret

addOffsetRight:
	fld dword [px1]
	fld dword [offset]
	fadd
	fstp dword [px1]
	ret

addOffsetLeft:
	fld dword [px1]
	fld dword [offset]
	fsub
	fstp dword [px1]
	ret

pixelBlanco:
	mov ah, 0Ch
	mov al, 1111b ;blanco
	mov bh, 00h
	int 10h
	ret

teclado:
	mov ah, 01h
	int 16h
	jnz tecret
	mov ah, 00h
	int 16h
tecret:
	;call movimientoautomatico
	ret

movimientoautomatico:
	call sleep_half_s
ma1:
	cmp bx, 1d
	jne ma2
	call UpA
ma2:
	cmp bx, 2d
	jne ma3
	call DownA
ma3:
	cmp bx, 3d
	jne ma4
	call LeftA
ma4:
	cmp bx, 4d
	jne maret
	call RightA
maret:ret

movimiento:
	cmp al, 'w'
	je Up
	cmp al, 's'
	je Down
	cmp al, 'a'
	je Left
	cmp al, 'd'
	je Right
	cmp al, ' '
	je fin
	jmp main
Up: ; Orientación 1
	call UpA
	mov bx, 1d
	jmp main
Down: ; Orientación 2
	call DownA
	mov bx, 2d
	jmp main
Left: ; Orientación 3
	call LeftA
	mov bx, 3d
	jmp main
Right: ; Orientación 4
	call RightA
	mov bx, 4d
	jmp main

UpA: ; Orientación 1
	call addOffsetUp
	call clear_screen
	call drawSnake
	ret
DownA: ; Orientación 2
	call addOffsetDown
	call clear_screen
	call drawSnake
	ret
LeftA: ; Orientación 3
	call addOffsetLeft
	call clear_screen
	call drawSnake
	ret
RightA: ; Orientación 4
	call addOffsetRight
	call clear_screen
	call drawSnake
	ret

fin: 
	int 20h
	ret