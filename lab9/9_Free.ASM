Assume cs:code, ds:data, ss:stack

data segment 
incorrectpw db "Incorrect Password $"
openmessage DB "Please Enter the Password:$"
password db "cpe$"
Menu1 db "Press Button 1 for Pattern 1 $"
menu2 db "Press Button 2 for Pattern 2 $"
menu3 db "Press Button 3 for Pattern 3 $"
menu4 db "Press Button 4 to quit $"
button1 db "Button 1 is pressed$"
button2 db "Button 2 is pressed$"
button3 db "Button 3 is pressed$"
Input db 20 dup(0) 
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


mov DX,143H
mov al,02h ;ctrl reg is direction mode
out dx,al

mov dx,141h
mov al,0ffh ;port b is all outputs (i.e. LED pins)
out dx,al

mov dx, 140h
mov al, 00h ;port a is all inputs (i.e. push buttons...but you only need 4)
out dx,al  

mov dx,143h
mov al,03h ;ctrl reg back in operation mode
out dx,al

;MAIN
call getPassword
call passCheck
call MainMenu

exitProg:
mov ah,4ch
int 21h

getPassword:
push ax
push cx
push dx
push di
push si


pop si
pop di
pop dx
pop cx
pop ax
ret

passCheck:
push ax
push bx
push dx
push di
push si

pop si
pop di
pop dx
pop bx
pop ax
ret

MainMenu:

ret

resetInput:  ;clears out our user input password storage variable with zeros
push bx
push cx
push si
mov bl,00h
mov cx,20
mov si, offset input
qqq:
mov [si],bl
inc si
loop qqq
pop si
pop cx
pop bx
ret



;-------------------------------------------------DELAY------------------------
delay:
	push bx
	push cx
	mov cx,14h
	mov bx,0FFFFH
	InnerLoop:
		nop
		nop
		nop
		dec bx
		cmp bx,0
		jne InnerLoop
		mov bx,0FFFFH
		dec cx
		cmp cx,0
		jne InnerLoop
	pop cx
	pop bx
ret



Pattern1:
push ax
push cx


pop cx
pop ax
ret

Pattern2:
push ax


pop ax
ret

Pattern3:
push ax
push bx
push cx



pop cx
pop bx
pop ax
ret

outputb:
push dx
mov dx,141h
out dx,al 
call delay
pop dx
ret

turnoff:
push ax
push dx
mov al,0ffh
mov dx,141h
out dx,al
pop dx
pop ax
ret

;-------------------------------------------------PRINT----------------------------------
print:
	push ax
	push dx
	mov ah,2

	;this block adds new line and places
	;cursor at the beginning of new line
	mov dl,0dh
	int 21h
	mov dl,0Ah
	int 21h

	abc1:
		mov dl,[si]
		cmp dl,"$"
		je here1
		int 21h
		inc si
		jmp abc1
	here1:
	pop dx
	pop ax
ret

;THIS IS WHERE YOUR CODE ENDS
code ends
end begin
