Assume cs:code, ds:data, ss:stack

data segment 
; All variables defined within the data segment
mess db "Lab 4 Exercise 1$"
storage DB "                 "


data ends

stack segment  
;Stack size and the top of the stack defined in the stack segment
dw 100 dup(?)
stacktop:
stack ends

code segment
begin:	
mov ax, data
mov ds,ax
mov ax, stack
mov ss,ax
mov sp, offset stacktop
;THIS IS WHERE YOUR CODE BEGINS

mov si , offset mess ;set si's starting point
mov di , offset storage ;set di's starting point

transfer:;loop that moves one bite from one memory location to another 
	mov al,[si]
	mov [di],al
	cmp al,"$"; checking for terminator
	je endit;get out of loop
	inc si
	inc di
	jmp transfer ;loops till terminator
endit:

mov di , offset storage;resets di to the srtart

printer:;loops that copies char into dl and prints until dl==$
	mov dl,[di]
	cmp dl,"$"; checking for terminator
	je endit1;get out of loop
	mov ah,2
	int 21h
	inc di
	jmp printer
endit1:

;kills prog
mov ah,4ch
int 21h
;THIS IS WHERE YOUR CODE ENDS
code ends
end begin