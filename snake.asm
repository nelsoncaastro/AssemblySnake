org 100h ;Indica en que dirección de memoria comienza el programa.

section .bss ;Sección donde declaramos variables, solo reservamos memoria.

sigpx1: resd 1 ;Variable para almacenar la siguiente posición de X del jugador
sigpy1: resd 1 ;Variable para almacenar la siguiente posición de Y del jugador
auxpx1:	resd 1 ;Variable para almacenar la transición de la posición de X del jugador
auxpy1: resd 1 ;Variable para almacenar la transición de la posición de Y del jugador
sigfx1: resd 1
sigfy1: resd 1

pheadori: resb 1 

px2: resd 1
py2: resd 1
p2ori: resb 1

px3: resd 1
py3: resd 1
p3ori: resb 1

px4: resd 1
py4: resd 1
p4ori: resb 1

px5: resd 1
py5: resd 1
p5ori: resb 1

px6: resd 1
py6: resd 1
p6ori: resb 1

px7: resd 1
py7: resd 1
p7ori: resb 1

px8: resd 1
py8: resd 1
p8ori: resb 1

px9: resd 1
py9: resd 1
p9ori: resb 1

px10: resd 1
py10: resd 1
p10ori: resb 1

section .data ;Sección donde inicializamos variables.

px1: dd  320d ;Variable para almacenar la posición de X actual del jugador
py1: dd	 204d ;Variable para almacenar la posición de X actual del jugador
offset: dd 20d ;Tamaño del cuadro del culebrón

fx1: dd 100d
fy1: dd 50d
foffset: dd 15d

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