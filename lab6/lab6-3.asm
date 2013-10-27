Assume cs:code, ds:data, ss:stack
data segment 
; All variables defined within the data segment
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
; configures board to be used
mov dx, 143h ; set direction mode
mov al,02h
out dx,al
mov dx,141h ; set port b to all outputs
mov al,0ffh
out dx,al
mov dx,143h ; set operation mode
mov al,03h
out dx,al 
; end configure the board to be used

turnon:; loop to turn all lights on
	mov dx,141h
	mov al,000h
	out dx,al
; end turn on all lights
	call delay
; turn all lights off
	mov dx,141h
	mov al,0ffh
	out dx,al
; end turn all lights off
	call delay
jmp turnon

; delay loop
delay:
	mov bx,0ffffh
	mov cx,20h
delay1:
	nop
	dec bx
	cmp bx,0
	jne delay1
	mov bx,0ffffh
	dec cx
	cmp cx,0
jne delay1
ret
; end delay loop
;THIS IS WHERE YOUR CODE ENDS
mov ah,4ch
int 21h
code ends
end begin