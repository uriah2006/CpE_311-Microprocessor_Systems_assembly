Assume cs:code, ds:data, ss:stack

data segment 
; All variables defined within the data segment
mess db "Lab 4 Exercise 1$"

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
mov ah,2
mov dl,"y"
int 21h

mov ah,2
mov dl,"o"
int 21h

mov dl,"l"
int 21h

mov dl,"o"
int 21h

mov ah,4ch
int 21h

;THIS IS WHERE YOUR CODE ENDS
code ends
end begin