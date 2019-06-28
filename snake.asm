org 100h ;Indica en que dirección de memoria comienza el programa.

section .bss ;Sección donde declaramos variables, solo reservamos memoria.

sigpx1: resd 1 ;Variable para almacenar la siguiente posición de X del jugador
sigpy1: resd 1 ;Variable para almacenar la siguiente posición de Y del jugador
auxpx1:	resd 1 ;Variable para almacenar la transición de la posición de X del jugador
auxpy1: resd 1 ;Variable para almacenar la transición de la posición de Y del jugador
sigfx1: resd 1
sigfy1: resd 1

section .data ;Sección donde inicializamos variables.

px1: dd  320d ;Variable para almacenar la posición de X actual del jugador
py1: dd	 204d ;Variable para almacenar la posición de X actual del jugador
offset: dd 20d ;Tamaño del cuadro del culebrón
pheadori: db 0 

snakesize: db 1
actualpos: db 1

fx1: dd 100d
fy1: dd 50d
foffset: dd 15d

px2: dd 0
py2: dd 0
p2ori: db 0

px3: dd 0
py3: dd 0
p3ori: db 0

px4: dd 0
py4: dd 0
p4ori: db 0

px5: dd 0
py5: dd 0
p5ori: db 0

px6: dd 0
py6: dd 0
p6ori: db 0

px7: dd 0
py7: dd 0
p7ori: db 0

px8: dd 0
py8: dd 0
p8ori: db 0

px9: resd 0
py9: resd 0
p9ori: db 0

px10: resd 0
py10: resd 0
p10ori: db 0

section .text ;Sección del código fuente

global start

start:
    call iniciarModoVideo
	finit
lupita:
	call drawLimits
	call drawFruit
	call drawSnake
	call teclado
	call movimiento
	call moveyourbody
	call checkLimits
	call checkFruit
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

drawFruit:
	mov ecx, [fx1]
	mov edx, [fy1]
	call fsigposition
fsigd:call pixelVerde
	inc ecx
	cmp ecx, [sigfx1]
	jne fsigd
	mov ecx, [fx1]
	inc edx
	cmp edx, [sigfy1]
	jne fsigd
	ret

fsigposition:
	fld dword [fx1]
	fld dword [foffset]
	fadd
	fstp dword [sigfx1]
	fld dword [fy1]
	fld dword [foffset]
	fadd
	fstp dword [sigfy1]
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

moveyourbody:
	mov byte [actualpos], 1
	call movimientoautomatico
	cmp byte [snakesize],1
	je myret
	mov byte [actualpos], 2
	call movimientoautomatico
	cmp byte [snakesize],2
	je myret
	mov byte [actualpos], 3
	call movimientoautomatico
	cmp byte [snakesize],3
	je myret
	mov byte [actualpos], 4
	call movimientoautomatico
	cmp byte [snakesize],4
	je myret
	mov byte [actualpos], 5
	call movimientoautomatico
	cmp byte [snakesize],5
	je myret
	mov byte [actualpos], 6
	call movimientoautomatico
	cmp byte [snakesize],6
	je myret
	mov byte [actualpos], 7
	call movimientoautomatico
	cmp byte [snakesize],7
	je myret
	mov byte [actualpos], 8
	call movimientoautomatico
	cmp byte [snakesize],8
	je myret
	mov byte [actualpos], 9
	call movimientoautomatico
	cmp byte [snakesize],9
	je myret
	mov byte [actualpos], 10
	call movimientoautomatico
	cmp byte [snakesize], 10
	je myret
myret:ret

movimientoautomatico:
	call getactualposinsi
	call sleep_half_s
cma1:cmp si, 1
	jne cma2
	call UpA
cma2:cmp si, 2
	jne cma3
	call DownA
cma3:cmp si, 3
	jne cma4
	call LeftA
cma4:cmp si, 4
	jne maret
	call RightA
maret:ret

getactualposinsi:
	cmp byte [actualpos], 1
	jne gma1
	mov si, [pheadori]
gma1:cmp byte [actualpos], 2
	jne gma2
	mov si, [p2ori]
gma2:cmp byte [actualpos], 3
	jne gma3
	mov si, [p3ori]
gma3:cmp byte [actualpos], 4
	jne gma4
	mov si, [p4ori]
gma4:cmp byte [actualpos], 5
	jne gma5
	mov si, [p5ori]
gma5:cmp byte [actualpos], 6
	jne gma6
	mov si, [p6ori]
gma6:cmp byte [actualpos], 7
	jne gma7
	mov si, [p7ori]
gma7:cmp byte [actualpos], 8
	jne gma8
	mov si, [p8ori]
gma8:cmp byte [actualpos], 9
	jne gma9
	mov si, [p9ori]
gma9:cmp byte [actualpos], 10
	jne gma10
	mov si, [p10ori]
gma10:ret

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


checkLimits:
	cmp dword [px1], 0d
	jne ccl2
	call fin
ccl2:cmp dword [px1], 640d
	jne ccl3
	call fin
ccl3:cmp dword [py1], 10d
	jnb ccl4
	call fin
ccl4:cmp dword [sigpy1], 410d
	jna clret
	call fin
clret:ret

checkFruit:
	finit
	fld dword [fx1] ; stack(st1)
	fld dword [px1] ; stack(st0)
	fcom st0, st1
	fstsw ax

	and eax, 0100011100000000B  ; operación binaria para solo considerar las banderas de condición
	cmp eax, 0000000100000000B   ; st0 < st1
	je cf1
	jmp checkret

cf1:
	finit
	fld dword [fx1] ; stack(st1)
	fld dword [sigpx1] ; stack(st0)
	fcom st0, st1
	fstsw ax

	and eax, 0100011100000000B ; operación binaria para solo considerar las banderas de condición
	cmp eax, 0000000000000000B ; st0 > st1
	je cf2
	jmp checkret

cf2:
	finit
	fld dword [fy1] ; stack(st1)
	fld dword [py1] ; stack(st0)
	fcom st0, st1
	fstsw ax

	and eax, 0100011100000000B 	 ; operación binaria para solo considerar las banderas de condición
	cmp eax, 0000000100000000B   ; st0 < st1
	je cf3
	jmp checkret

cf3:
	finit
	fld dword [fy1] ; stack(st1)
	fld dword [sigpy1]  ; stack(st0)
	fcom st0, st1
	fstsw ax

	and eax, 0100011100000000B ;operación binaria para solo considerar las banderas de condición
	cmp eax, 0000000000000000B ; st0 > st1
	je cfa
	jmp checkret

cfa:call fin
checkret:ret

eatFruit:
	ret