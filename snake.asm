org 100h ;Indica en que dirección de memoria comienza el programa.

section .bss ;Sección donde declaramos variables, solo reservamos memoria.

sigpx1: resd 1
sigpy1: resd 1

section .data ;Sección donde inicializamos variables.

px1: dd  20
py1: dd	 20

section .text ;Sección del código fuente

global start

start:
    call iniciarModoVideo
	finit

;=======Subrutinas

iniciarModoVideo:
	mov ah, 00h
	mov al, 12h
	int 10h
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
	ret

sigposition:
	fld dword [px1]
	fld dword [5d]
	fadd
	fstp dword [sigpx1]
	fld dword [py1]
	fld dword [5d]
	fadd
	fstp dword [sigpy1]
	ret

pixelBlanco:
	mov ah, 0Ch
	mov al, 1111b ;blanco
	mov bh, 00h
	int 10h
	ret

espera:
	mov ah, 00
	int 16h
	ret
	
fin: 
	int 21h
	ret