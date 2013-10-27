Assume cs:code, ds:data, ss:stack
data segment 
; All variables defined within the data segment
counter1 db 0fh 		; Counter for pattern 1
counter2 db 03h 		; Counter for pattern 2
counter3 db 03h 		; Counter for pattern 3

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
call outb ; Configure board

mov al, 01000010b 				; Set Initial pattern
loop1:
dec counter1					;decrecses the counter by one
call pattern1					
cmp counter1,0 					; Continue looping if counter not 0
jne loop1

mov al, 01111111b 				; Set Initial pattern
loop2:
call pattern2
dec counter2
cmp counter2, 0 				; Continue looping if counter not 0
jne loop2

mov bx, 1111111100001111b		; Set Initial pattern
mov cx, 1111000011111111b		; Set Initial pattern
mov al, 11111111b				; Set Initial pattern

patt3loop:
call pattern3
dec counter3
cmp counter3, 0 				; Continue looping if counter not 0
jne patt3loop
jmp ender

; -----------------subroutines------------------

outb: 					; board config
mov dx, 143h 			; set direction mode
mov al,02h
out dx,al
mov dx,141h				; set port b to all outputs
mov al,0ffh
out dx,al
mov dx,143h 			; set operation mode
mov al,03h
out dx,al 
ret 					;end outb 



pattern1: 				; start pattern 1
call output				;output to board and delay
not al					; light on go off light off come on
ret

; makes pattern 2
pattern2:
call output				;output to board and delay
rotateright:			;rolls right
cmp al, 11111110b		; Check for end of rotate left
je rotateleft			; loops till ther light is on on the right
ror al, 1				; al is rolled right by 1 position
call output				;output to board and delay
jmp rotateright
rotateleft:				;rolls left
cmp al, 01111111b		; check for end of rotate right
je patt2return			;loops till ther light is on on the left
rol al, 1				; al is rolled left by 1 position
call output				;output to board and delay
jmp rotateleft
patt2return:
ret; end pattern 2


pattern3:; pattern 3
shifti:
cmp al, 11000011b 		; check for the last pattern befor reversing it 
je shifto				;
ror cx, 1				;roll cx right 1 
rol bx, 1				;roll bx left 1
mov al, bh				;it is 'anding' bh and cl to make the next pattern
and al, cl				;
call output				;output to board and delay
jmp shifti
shifto:					;reverse of shifti
cmp al, 11111111b 		;check for the last pattern befor ending it
je patt3return			;end it
rol cx, 1				;roll cx left 1 
ror bx, 1				;roll bx right 1 
mov al, bh				;it is 'anding' bh and cl to mak the pattern
and al, cl
call output				;output to board and delay
jmp shifto
patt3return:
ret ;end pattern 3 


output: 				; output to port B
mov dx,141h
out dx,al
call delay
ret 					;end output


delay: 					; delay loop we have already created a delay loop
push bx
push cx
mov bx,0ffffh
mov cx,20h
delay1:
nop						; killing time
dec bx
cmp bx,0
jne delay1
mov bx,0ffffh
dec cx
cmp cx,0
jne delay1
pop cx
pop bx
ret 					; end delay loop

;THIS IS WHERE YOUR CODE ENDS
; ends the program
ender:
mov ah,4ch
int 21h
code ends
end begin