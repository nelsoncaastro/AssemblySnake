org 100h ;Indica en que dirección de memoria comienza el programa

section .bss ;Sección donde declaramos variables, solo reservamos memoria

section .text ;Sección del código fuente

global start

start:
    call iniciarModoVideo


;=======Subrutinas

iniciarModoVideo:
	mov ah, 00h
	mov al, 12h
	int 10h
	ret


