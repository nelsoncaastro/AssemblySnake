org 100h ;Indica en que dirección de memoria comienza el programa.

section .bss ;Sección donde declaramos variables, solo reservamos memoria.

sigpx1: resw 1 ;Variable para almacenar la siguiente posición de X del jugador
sigpy1: resw 1 ;Variable para almacenar la siguiente posición de Y del jugador
auxpx1:	resw 1 ;Variable para almacenar la transición de la posición de X del jugador
auxpy1: resw 1 ;Variable para almacenar la transición de la posición de Y del jugador
sigfx1: resw 1
sigfy1: resw 1

section .data ;Sección donde inicializamos variables.

px1: dw  320d ;Variable para almacenar la posición de X actual del jugador
py1: dw	 204d ;Variable para almacenar la posición de X actual del jugador
offset: dw 20d ;Tamaño del cuadro del culebrón
pheadori: db 0 

snakesize: db 1

fx1: dw 100d
fy1: dw 50d
foffset: dw 15d

px2: dw 0
py2: dw 0
p2ori: db 0

px3: dw 0
py3: dw 0
p3ori: db 0

px4: dw 0
py4: dw 0
p4ori: db 0

px5: dw 0
py5: dw 0
p5ori: db 0

px6: dw 0
py6: dw 0
p6ori: db 0

px7: dw 0
py7: dw 0
p7ori: db 0

px8: dw 0
py8: dw 0
p8ori: db 0

px9: dw 0
py9: dw 0
p9ori: db 0

px10: dw 0
py10: dw 0
p10ori: db 0

section .text ;Sección del código fuente

global start

start:
    call iniciarModoVideo
lupita:
	call drawLimits
	call drawFruit
	call drawSnake
	call teclado
	call movimiento
	call movimientoautomatico
	;call checkLimits
	;call checkFruit
	jmp lupita

;=======Subrutinas

fin: 
	int 20h
	ret

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

drawSnake:
	mov cx, [px1]
	mov dx, [py1]
	call sigposition
sigd:call pixelBlanco
	inc cx	
	cmp cx, [sigpx1]
	jne sigd
	mov cx, [px1]
	inc dx
	cmp dx, [sigpy1]
	jne sigd
	ret

drawFruit:
	mov cx, [fx1]
	mov dx, [fy1]
	call fsigposition
fsigd:call pixelVerde
	inc cx
	cmp cx, [sigfx1]
	jne fsigd
	mov cx, [fx1]
	inc dx
	cmp dx, [sigfy1]
	jne fsigd
	ret

fsigposition:
	mov bx, [fx1]
	add bx, [foffset]
	mov [sigfx1], bx
	mov bx, [fy1]
	add bx, [foffset]
	mov [sigfy1], bx
	ret

sigposition:
	mov bx, [px1]
	add bx, [offset]
	mov [sigpx1], bx
	mov bx, [py1]
	add bx, [offset]
	mov [sigpy1], bx
	ret

addOffsetUp:
	mov bx, [py1]
	sub bx, [offset]
	mov [py1], bx
	ret

addOffsetDown:
	mov bx, [py1]
	add bx, [offset]
	mov [py1], bx
	ret

addOffsetRight:
	mov bx, [px1]
	add bx, [offset]
	mov [px1], bx
	ret

addOffsetLeft:
	mov bx, [px1]
	sub bx, [offset]
	mov [px1], bx
	ret

pixelBlanco:
	mov ah, 0Ch
	mov al, 1111b ;blanco
	mov bh, 00h
	int 10h
	ret

pixelVerde:
	mov ah, 0Ch
	mov al, 1010b ;verde
	mov bh, 00h
	int 10h
	ret

teclado:
	mov ah, 01h
	int 16h ; Llamar función 1 de la INT 16h
	jz tecret
	mov ah, 00h
	int 16h
tecret: ret

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
	jmp movsal
Up: 
	call UpA
	mov byte [pheadori], 1
	jmp movsal
Down: 
	call DownA
	mov byte [pheadori], 2
	jmp movsal
Left: 
	call LeftA
	mov byte [pheadori], 3
	jmp movsal
Right: 
	call RightA
	mov byte [pheadori], 4
movsal:ret

movimientoautomatico:
	call sleep_half_s
cma1:cmp byte [pheadori], 1d
	jne cma2
	call UpA
cma2:cmp byte [pheadori], 2d
	jne cma3
	call DownA
cma3:cmp byte [pheadori], 3d
	jne cma4
	call LeftA
cma4:cmp byte [pheadori], 4d
	jne maret
	call RightA
maret:ret

UpA: ; Orientación 1
	call addOffsetUp
	call clear_screen
	ret
DownA: ; Orientación 2
	call addOffsetDown
	call clear_screen
	ret
LeftA: ; Orientación 3
	call addOffsetLeft
	call clear_screen
	ret
RightA: ; Orientación 4
	call addOffsetRight
	call clear_screen
	ret

drawLimits:
	mov cx, 0d
	mov dx, 0d
sigl1:
	call pixelBlanco
	inc cx
	cmp cx, 639d
	jne sigl1

	mov cx, 0d
	mov dx, 408d
sigl2:
	call pixelBlanco
	inc cx
	cmp cx, 639d
	jne sigl2

	mov cx, 0d
	mov dx, 0d
sigl3:
	call pixelBlanco
	inc dx
	cmp dx, 408d
	jne sigl3

	mov cx, 639d
	mov dx, 0d
sigl4:
	call pixelBlanco
	inc dx
	cmp dx, 408d
	jne sigl4
	ret


checkLimits:
	cmp word [px1], 0d
	jne ccl2
	call fin
ccl2:cmp word [px1], 640d
	jne ccl3
	call fin
ccl3:cmp word [py1], 10d
	jnb ccl4
	call fin
ccl4:cmp word [sigpy1], 410d
	jna clret
	call fin
clret:ret

checkFruit:
	mov bx, [fx1]
	cmp [px1], bx
	jb cf1
	jmp checkret
cf1:
	cmp [sigpx1], bx
	jg cf2
	jmp checkret
cf2:
	mov bx, [fy1]
	cmp [py1], bx
	jb cf3
	jmp checkret
cf3:
	cmp [sigpy1], bx
	jg cfa
	jmp checkret

cfa:call fin
checkret:ret

eatFruit:
	ret