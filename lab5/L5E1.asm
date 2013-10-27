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
;this loads si with message
;moves si to dl abd then priints what is in si 
;increments si until it equals the kill letter $

Mov si, offset mess
abc:
Mov dl,[si]
Cmp dl,"$"
Je Ender
Mov ah,2
Int 21h
Inc si
Jmp abc
Ender:


;CODE ENDS
code ends
end begin
