Assume cs:code, ds:data, ss:stack

data segment 

;line is written to data
mess db "Lab 4 Exercise 1$"
var db "w"

data ends

stack segment  

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

; codes start

Mov si, offset mess;sets si to start of mess
mov bx,0

abc:;loop adds bx and si to print from mess
	mov dl,[bx+si]
	cmp dl,"$";checks for terminator
	je ender
	mov ah,2
	int 21h
	inc bx
	jmp abc
ender:

;ends program

mov ah,4ch
int 21h

;CODE ENDS
code ends
end begin
