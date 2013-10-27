Assume cs:code, ds:data, ss:stack

data segment 
; All variables defined within the data segment
string db 20 dup(?) ; input variable
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

mov si, offset string 	; set the pointer to the beginning of the input variable
main:					;main program
mov ah, 01h 			;01 for eco 08 for no echo
int 21h					
mov [si], al			;moves one char  in to memory
cmp al, 0dh				;checks if the last char is the terminator
je printall				;the way out
inc si
jmp main				;looper
printall:				
call print

mov ah,4ch				;end program
int 21h


;------------------subroutines------------
print: 					;loops till it prints the whole message
mov si, offset string	;sets pointer to the begining
push ax					;move the content of a register into the stack
push dx					;
mov dl, 0ah				;move byte to data lower
mov ah,2				;move to acumlator high
int 21h
mov dl,0dh				;move byte to data lower
int 21h

abc:
mov dl,[si]				;move from memory to data lower
cmp dl, 0dh				;checks if it is terminator
je return				;if so then it will go to return
mov ah,2				
int 21h
inc si					;moves the pointer to the next char
jmp abc
return:
mov si, offset string	;resets the pointer
pop dx					;extracts the content of the last position of the stack into dx register
pop ax					;extracts the content of the last position of the stack into ax register
ret

;THIS IS WHERE YOUR CODE ENDS
code ends
end begin