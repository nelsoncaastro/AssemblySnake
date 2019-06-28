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
	call movimientoautomatico
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

addOffsetUp2:
	fld dword [py2]
	fld dword [offset]
	fsub
	fstp dword [py2]
	ret
addOffsetDown2:
	fld dword [py2]
	fld dword [offset]
	fadd
	fstp dword [py2]
	ret
addOffsetRight2:
	fld dword [px2]
	fld dword [offset]
	fadd
	fstp dword [px1]
	ret
addOffsetLeft2:
	fld dword [px2]
	fld dword [offset]
	fsub
	fstp dword [px1]
	ret

addOffsetUp3:
	fld dword [py3]
	fld dword [offset]
	fsub
	fstp dword [py3]
	ret
addOffsetDown3:
	fld dword [py3]
	fld dword [offset]
	fadd
	fstp dword [py3]
	ret
addOffsetRight3:
	fld dword [px3]
	fld dword [offset]
	fadd
	fstp dword [px3]
	ret
addOffsetLeft3:
	fld dword [px3]
	fld dword [offset]
	fsub
	fstp dword [px3]
	ret

addOffsetUp4:
	fld dword [py4]
	fld dword [offset]
	fsub
	fstp dword [py4]
	ret
addOffsetDown4:
	fld dword [py4]
	fld dword [offset]
	fadd
	fstp dword [py4]
	ret
addOffsetRight4:
	fld dword [px4]
	fld dword [offset]
	fadd
	fstp dword [px4]
	ret
addOffsetLeft4:
	fld dword [px4]
	fld dword [offset]
	fsub
	fstp dword [px4]
	ret

addOffsetUp5:
	fld dword [py5]
	fld dword [offset]
	fsub
	fstp dword [py5]
	ret
addOffsetDown5:
	fld dword [py5]
	fld dword [offset]
	fadd
	fstp dword [py5]
	ret
addOffsetRight5:
	fld dword [px5]
	fld dword [offset]
	fadd
	fstp dword [px5]
	ret
addOffsetLeft5:
	fld dword [px5]
	fld dword [offset]
	fsub
	fstp dword [px5]
	ret

addOffsetUp6:
	fld dword [py6]
	fld dword [offset]
	fsub
	fstp dword [py6]
	ret
addOffsetDown6:
	fld dword [py6]
	fld dword [offset]
	fadd
	fstp dword [py6]
	ret
addOffsetRight6:
	fld dword [px6]
	fld dword [offset]
	fadd
	fstp dword [px6]
	ret
addOffsetLeft6:
	fld dword [px6]
	fld dword [offset]
	fsub
	fstp dword [px6]
	ret

addOffsetUp7:
	fld dword [py7]
	fld dword [offset]
	fsub
	fstp dword [py7]
	ret
addOffsetDown7:
	fld dword [py7]
	fld dword [offset]
	fadd
	fstp dword [py7]
	ret
addOffsetRight7:
	fld dword [px7]
	fld dword [offset]
	fadd
	fstp dword [px7]
	ret
addOffsetLeft7:
	fld dword [px7]
	fld dword [offset]
	fsub
	fstp dword [px7]
	ret

addOffsetUp8:
	fld dword [py8]
	fld dword [offset]
	fsub
	fstp dword [py8]
	ret
addOffsetDown8:
	fld dword [py8]
	fld dword [offset]
	fadd
	fstp dword [py8]
	ret
addOffsetRight8:
	fld dword [px8]
	fld dword [offset]
	fadd
	fstp dword [px8]
	ret
addOffsetLeft8:
	fld dword [px8]
	fld dword [offset]
	fsub
	fstp dword [px8]
	ret

addOffsetUp9:
	fld dword [py9]
	fld dword [offset]
	fsub
	fstp dword [py9]
	ret
addOffsetDown9:
	fld dword [py9]
	fld dword [offset]
	fadd
	fstp dword [py9]
	ret
addOffsetRight9:
	fld dword [px9]
	fld dword [offset]
	fadd
	fstp dword [px9]
	ret
addOffsetLeft9:
	fld dword [px9]
	fld dword [offset]
	fsub
	fstp dword [px9]
	ret

addOffsetUp10:
	fld dword [py10]
	fld dword [offset]
	fsub
	fstp dword [py10]
	ret
addOffsetDown10:
	fld dword [py10]
	fld dword [offset]
	fadd
	fstp dword [py10]
	ret
addOffsetRight10:
	fld dword [px10]
	fld dword [offset]
	fadd
	fstp dword [px10]
	ret
addOffsetLeft10:
	fld dword [px10]
	fld dword [offset]
	fsub
	fstp dword [px10]
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

UpA2: ; Orientación 1
	call addOffsetUp2
	call clear_screen
	ret
DownA2: ; Orientación 2
	call addOffsetDown2
	call clear_screen
	ret
LeftA2: ; Orientación 3
	call addOffsetLeft2
	call clear_screen
	ret
RightA2: ; Orientación 4
	call addOffsetRight2
	call clear_screen
	ret

UpA3: ; Orientación 1
	call addOffsetUp3
	call clear_screen
	ret
DownA3: ; Orientación 2
	call addOffsetDown3
	call clear_screen
	ret
LeftA3: ; Orientación 3
	call addOffsetLeft3
	call clear_screen
	ret
RightA3: ; Orientación 4
	call addOffsetRight3
	call clear_screen
	ret

UpA4: ; Orientación 1
	call addOffsetUp4
	call clear_screen
	ret
DownA4: ; Orientación 2
	call addOffsetDown4
	call clear_screen
	ret
LeftA4: ; Orientación 3
	call addOffsetLeft4
	call clear_screen
	ret
RightA4: ; Orientación 4
	call addOffsetRight4
	call clear_screen
	ret

UpA5: ; Orientación 1
	call addOffsetUp5
	call clear_screen
	ret
DownA5: ; Orientación 2
	call addOffsetDown5
	call clear_screen
	ret
LeftA5: ; Orientación 3
	call addOffsetLeft5
	call clear_screen
	ret
RightA5: ; Orientación 4
	call addOffsetRight5
	call clear_screen
	ret

UpA6: ; Orientación 1
	call addOffsetUp6
	call clear_screen
	ret
DownA6: ; Orientación 2
	call addOffsetDown6
	call clear_screen
	ret
LeftA6: ; Orientación 3
	call addOffsetLeft6
	call clear_screen
	ret
RightA6: ; Orientación 4
	call addOffsetRight6
	call clear_screen
	ret

UpA7: ; Orientación 1
	call addOffsetUp7
	call clear_screen
	ret
DownA7: ; Orientación 2
	call addOffsetDown7
	call clear_screen
	ret
LeftA7: ; Orientación 3
	call addOffsetLeft7
	call clear_screen
	ret
RightA7: ; Orientación 4
	call addOffsetRight7
	call clear_screen
	ret

UpA8: ; Orientación 1
	call addOffsetUp8
	call clear_screen
	ret
DownA8: ; Orientación 2
	call addOffsetDown8
	call clear_screen
	ret
LeftA8: ; Orientación 3
	call addOffsetLeft8
	call clear_screen
	ret
RightA8: ; Orientación 4
	call addOffsetRight8
	call clear_screen
	ret

UpA9: ; Orientación 1
	call addOffsetUp9
	call clear_screen
	ret
DownA9: ; Orientación 2
	call addOffsetDown9
	call clear_screen
	ret
LeftA9: ; Orientación 3
	call addOffsetLeft9
	call clear_screen
	ret
RightA9: ; Orientación 4
	call addOffsetRight9
	call clear_screen
	ret

UpA10: ; Orientación 1
	call addOffsetUp10
	call clear_screen
	ret
DownA10: ; Orientación 2
	call addOffsetDown10
	call clear_screen
	ret
LeftA10: ; Orientación 3
	call addOffsetLeft10
	call clear_screen
	ret
RightA10: ; Orientación 4
	call addOffsetRight10
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