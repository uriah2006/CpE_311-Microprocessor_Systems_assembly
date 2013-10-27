Assume cs:code, ds:data, ss:stack

data segment 
counter1 db 08h
counter2 db 01h
counter3 db 01h
incorrectpw db "Incorrect Password $"
openmessage DB "Please Enter the Password:$"
password db "cpe$"
welcomw db "Main Menu $"
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

;Input and output setup
mov DX, 143H 				; set direction mode
mov al,02h
out dx,al
mov dx,141h 				; set port b to all outputs
mov al,0ffh
out dx,al
mov dx,142h 				; set port c to all inputs
mov al,00h
out dx,al
mov dx,143h 				; set operation mode
mov al,03h
out dx,al
;End Input and output setup


;MAIN
;call turnoff
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
mov di, offset input
mov si, offset openmessage
call print 					; ask the user for a password
input_loop:
mov ah,08h 					; set to accept keyboard input
int 21h 					; waiting for keypress
mov [di], al 				; storing the input
cmp al, 0dh 				; looking for ENTER
je end_password
mov ah,2
mov dl,"*"
int 21h 					;display a * for each character
inc di
jmp input_loop
end_password:
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
starter:
mov si, offset password 	;hardcoded password
mov di, offset input 		;user input password

check_loop:
	mov al,[si] 			;hardcoded password
	mov bl,[di] 			;user input password
	cmp al,bl 				;compare both passwords
	jne terminator			;get out 
	inc di 					;incrments si and di
	inc si
jmp check_loop

terminator:
	cmp al,"$" 				;look for end of password
	jne wrong 				;wrong password entered
	cmp bl,0dh
	jne wrong
	jmp accessGranted 		;password is correct

wrong:
	mov si, offset incorrectpw
	call print 				;print incorrect password message
	call resetInput 		;reset input storage
	call getPassword 		;get a new user password
	jmp starter
	
accessGranted:
pop si
pop di
pop dx
pop bx
pop ax
ret

MainMenu:
push ax
push si
mov si, offset menu1
call print
mov si, offset menu2
call print
mov si, offset menu3
call print
mov si, offset menu4
call print
menu:
	mov dx,142h 			; poll inputs
	in al,dx
	and al, 0fh 			; apply mask
	cmp al, 00001110b
	jne but2
	call Pattern1
	but2:
	cmp al, 00001101b
	jne but3
	call Pattern2
	but3:
	cmp al, 00001011b
	jne but4
	call Pattern3
	but4:
	cmp al, 00000111b
	je ender
jmp menu
ender:
pop si
pop ax
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



Pattern1:                     ;just copyed the code we had from lab 7
push ax
push si
mov si, offset button1
call print

mov al, 01000010b 				;set initial display
patt1loop:					;decrement counter1
call outputb 					;update LEDs
not al 							;invert display
dec counter1
cmp counter1,0
jne patt1loop 					;keep going
pop si
pop ax
ret

Pattern2:
push ax
push si
mov si, offset button2
mov al, 01111111b ;set initial display
call outputb 

rotateright:
ror al, 1
call outputb
cmp al, 11111110b ;check to see if time to rotate left
jne rotateright

rotateleft:
rol al,1
call outputb
cmp al,01111111b
jne rotateleft


pop si
pop ax
ret

Pattern3:
push ax
push si
mov si, offset button3

mov bx, 1111111100001111b
mov cx, 1111000011111111b
mov al, 11111111b
patt3loop:
jmp patt3



patt3:
shifti:
cmp al, 11000011b
je shifto
ror cx, 1
rol bx, 1
mov al, bh
and al, cl
call outputb
jmp shifti
shifto:
cmp al, 11111111b
je patt3return
rol cx, 1
ror bx, 1
mov al, bh
and al, cl
call outputb
jmp shifto
patt3return:
pop si
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
