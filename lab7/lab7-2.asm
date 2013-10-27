Assume cs:code, ds:data, ss:stack

data segment 
; All variables defined within the data segment
mess db "Lab 5 Exercise 2$"; my message
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

mov si, offset mess
call print

ender:
mov ah,4ch
int 21h

;subroutines
; Prints out the message
print:
push ax;places ax on top of the stack
push dx;places dx on top of the stack
abc:
	mov dl,[si]; move char in to dl
	cmp dl,"$" ; checking for terminator
	je return
	mov ah,2
	int 21h ; print char
	inc si ;refrence next char
jmp abc
return:
pop dx
pop ax
ret

;THIS IS WHERE YOUR CODE ENDS

code ends
end begin