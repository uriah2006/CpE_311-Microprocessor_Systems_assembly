Assume cs:code, ds:data, ss:stack

data segment 
counter1 db 08h
counter2 db 01h
counter3 db 01h
welcome db "Main Menu $"
Menu1 db "    up->o        $"
menu2 db " left->o o<-right$"
menu3 db "        o<-down  $"
menu4 db "Mode Select$"
menu5 db "Draw Erase Move Clear Screen 		Exit$"
menu6 db "Press any Button to Continue$"
exit1 db "What have you done!!!$"
exit2 db "This computer will now self destruct$"
exit3 db "I hope your happy!!!$"
exit4 db "BOOM!!!!$"
zero db "0$"
one db "1$"
two db "2$"
three db "3$"
four db "4$"
five db "5$"
six db "6$"
seven db "7$"
eight db "8$"
nine db "9$"
mode db 1
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

;Input and output setup **********************
mov DX, 143H 						; set direction mode
mov al,02h
out dx,al
mov dx,140h 						; set port a to input up down left right
mov al,000h							; push buttons start start as lows
out dx,al							
mov dx,141h 						; set port b to input d,e,m,es,q
mov al,000h							;push buttons start as lows
out dx,al	
mov dx,142h 						; set port c to all outputs
mov al,0ffh							; set leds start as highs
out dx,al
mov dx,143h 						; set operation mode******************************
mov al,03h
out dx,al
;End Input and output setup


;MAIN
call greeting						;call subroutine for the greeting
call erase_screen					;call subroutine to make the blank screen
call center							;set the cursor in the middle of the blank screen
call light_test						;turns on the leds to make sure the board is ready for use

menu:
	
	mov dx, 141h          			;polls port b
	in al, dx
	and al, 1fh  					;=============
	
	cmp al, 00011110b				;looks to see if the first mode button is pressed
	jne erase						;if the fisrt button is not pressed it goes to the next mode to check
	mov mode,1						;set mode to 1
	
erase:								;print " "
	cmp al, 00011101b				;check to see if the second button is pressed
	jne move						;if the secong button is not pressed it goes to the next mode to check
	mov mode, 2						;set mode to 2

move:								;move without changing anything
	cmp al, 00011011b 				;looks to see if the third button is pressed
	jne clear						;if the third button is not pressed it goes to the next mode to check
	mov mode, 3						;set mode to 3
	
clear:								;erase the drawing board
	cmp al, 00010111b    			;looks to see if the fourth button is pressed
	jne red_button					;if the fourth button is not pressed it goes to the next mode to check
	call erase_screen				;if the fourth button is pressed it starts this subroutine
	call center						;goes to the subroutine to place the cursor in the center
	
red_button:							;quit
	cmp al, 00001111b				;see if the fith buton is pressed
	jne arrows						;if no button is pressed it starts looking for direction buttons
	jmp exitProg					;starts subroutine to end program
	
	arrows:
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	
UP:
	cmp al, 00001110b				;campare port a input for the up button
	jne left						; go to the next command if this is the worng button
	call delay						;delay before rechecking button is correct
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						;apply mask
	cmp al, 00001110b				;recompare the input button
	jne left						;if a different button is pressed it jumps to the next command
	call north						;north is the subroutine for moving the cursor up
	call input						;depending on what mode it is indecides what is printed on teh screen
	mov dx,142h						;set up port c to recieve command
	mov al, 11111110b				;turn on the led for the up button
	out dx,al	
	
	
	
left:								;move left
	cmp al, 00001101b
	jne right
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	cmp al, 00001101b
	jne right
	call west
	call input
	mov dx,142h
	mov al, 11111101b
	out dx,al
	
	
right:								;move right
	cmp al, 00001011b
	jne down
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	cmp al, 00001011b
	jne down
	call east
	call input
	mov dx,142h
	mov al, 11111011b
	out dx,al
	
	
down:								;move down
	cmp al, 00000111b
	jne up_left
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	cmp al, 00000111b
	jne up_left
	call south
	call input
	mov dx,142h
	mov al, 11110111b
	out dx,al
	

up_left:							;move up and to the left
	cmp al, 00001100b
	jne up_right
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	cmp al, 00001100b
	jne up_right
	call north
	call west
	call input
	mov dx,142h
	mov al, 11101111b
	out dx,al
	
up_right:							;move up and to the right
	cmp al, 00001010b
	jne down_left
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh	 					; apply mask
	cmp al, 00001010b
	jne down_left
	call north
	call east
	call input
	mov dx,142h
	mov al, 11011111b
	out dx,al
			
down_left:							;move down and to the left
	cmp al, 00000101b
	jne down_right
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	cmp al, 00000101b
	jne down_right
	call south
	call west
	call input
	mov dx,142h
	mov al, 10111111b
	out dx,al
	
down_right:							;move down and to the right
	cmp al, 00000011b
	jne no_button
	call delay
	mov dx,140h 					; poll port a
	in al,dx
	and al, 0fh						; apply mask
	cmp al, 00000011b
	jne no_button
	call south
	call east
	call input
	mov dx,142h
	mov al, 01111111b
	out dx,al
		
no_button:							;if no button is pressed nothing happens it calls a delay and return to the beginning
	call delay						;pause between checking if there is a button pressed
	jmp menu						;return to the begining of the loop
	
	
exitProg:							;exits the program
call erase_screen
push ax
push si
	mov si, offset exit1			;calls the longer word string that starts to exit
	call print						;calls the print command for longer strings
	mov si, offset exit2			;calls the second exit string
	call print
	mov si, offset exit3			;calls the third exit string
	call print
	mov ah,2						
		mov si, offset nine			;moves 9 into the low data register to be printed 
		call print					;interrupt used for showing the output
		call delay
		call delay
		mov ah,2
		mov si, offset eight
		call print
		call delay
		call delay
		mov si, offset seven
		call print	
		call delay
		call delay
		mov ah,2
		mov si,offset six
		call print
		call delay
		call delay
		mov si, offset five
		call print	
		call delay
		call delay
		mov ah,2
		mov si,offset four
		call print
		call delay
		call delay
		mov si, offset three
		call print	
		call delay
		call delay
		mov ah,2
		mov si, offset two
		call print
		call delay
		call delay
		mov si, offset one
		call print	
		call delay
		call delay
		mov ah,2
		mov si, offset zero
		call print
		call delay
		call delay
		mov si, offset exit4
	call print
pop si
pop ax
mov ah,4ch
int 21h

;________________________--subru--__________________
light_test:				; loop to turn all lights on
	push dx
	push ax
	mov dx,142h			;port c
	mov al,000h			;loads turns all lights on comman
	out dx,al			; sends the command
	call delay			;leaves the lights on command for half a second
	call delay			;leaves it on for another half second
	mov dx,142h			;port c
	mov al,0ffh			;loads the turn off all lights
	out dx,al			;sends the command
	pop dx
	pop ax
ret


center:
mov ah,2
mov dh, 10	;row
mov dl, 39	;col
int 10h
call setcur
mov ah,2
		mov dl,"*"
		int 21h
		call rst
call setcur
ret


greeting:
push ax
push si
	mov si, offset welcome		;the preregistered string 
	call print					;routine to print out a longer string
	mov si, offset menu1
	call print
	mov si, offset menu2
	call print
	mov si, offset menu3	
	call print
	mov si, offset menu4
	call print
	mov si, offset menu5
	call print
	mov si, offset menu6
	call print
MOV   AH,9h						;this is the command cor press any key to continue
MOV   AH,7h
MOV   DX,00h
INT   21h
pop si
pop ax
ret

north:
	call read_cur				;find where the cursor is on the screen
	cmp dh,0					;checks if curser is at the top
	jne north_mov				;if it is move curser to bottem
		mov dh,23				;jumpsto the bottom row
		call setcur				;set the cursor to teh new location
		jmp north_out			;exit the subroutine
north_mov:						;mov the cursor up
	dec dh						
	call setcur
north_out:
ret

west:
	call read_cur
	cmp dl,0
	jne west_mov
		mov dl,78
		call setcur
		jmp west_out
west_mov:
	dec dl
	call setcur
west_out:
	ret
east:
	call read_cur
	cmp dl,78
	jne east_mov
		mov dl, 0
		call setcur
		jmp east_out
east_mov:
	inc dl
	call setcur
east_out:	
	ret

south:
	call read_cur
	cmp dh, 23
	jne south_mov
		mov dh, 0
		call setcur
		jmp south_out
south_mov:
	inc dh
	call setcur
south_out:
	ret
	
erase_screen:
mov cx, 42
	loopy1:
		mov ah, 2
		mov dl,0ah				;go to the nextline
		int 21h
		mov dl,0dh				;go to the begining of line 
		int 21h
	loop loopy1
ret

setcur:	 						;set cur
	mov ah,2
	mov bh,0 					;page number
	int 10h
ret

rst:							;reset cur
	call read_cur
	dec dl
	call setcur
ret

read_cur:						;reads cursor position
	mov ah, 03h
	mov bl,0
	int 10h
ret


input:  						;prints depending on mode 
	cmp mode,1
	jne m2
		mov ah,2
		mov dl,"*"
		int 21h
		call rst 
	m2:
	cmp mode, 2
	jne m3
		mov ah,2
		mov dl, " "
		int 21h
		call rst 
	m3:
ret

delay:
	push bx
	push cx
	mov cx,6h
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

print:
	push ax
	push dx
	mov ah,2

	mov dl,0dh					;this block adds new line and places
	int 21h						;cursor at the beginning of new line
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
