Assume cs:code, ds:data, ss:stack
data segment 
; All variables defined within the data segment
mess1 db "Button One Pressed$"
mess2 db "Button Two Pressed$"
;mess3 db "you fat fingerd it$" 				; this is something extra
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
mov dx, 143h 							; set direction mode
mov al,02h
out dx,al
mov dx,141h 							; set port b to all inputs
mov al,00h
out dx,al
mov dx,143h 							; set operation mode
mov al,03h
out dx,al 
; end configure the board to be used

main:									; Main loop
mov dx,141h 							; poll inputs
in al,dx
and al, 07h 							; apply mask
cmp al, 00000110b
je press1
cmp al, 00000101b
je press2
cmp al, 00000100b;test
;je press12
;cmp al, 00000011b
je ender
jmp main
; Button 1 press; pin 10
press1:
mov si, offset mess1
call print
but1:;test
	in al,dx 
	and al,07h
	cmp al,07h
jne but1	
jmp main

; Button 2 press; pin 8
press2:
mov si, offset mess2
call print
but2:
	in al,dx 
	and al,07h
	cmp al,07h
jne but2
jmp main

; button 12  press; pin 10 and 8		; this is the other thing that i added for fun
;press12:
;mov si, offset mess3
;call print
;but12:
;	in al,dx 
;	and al,07h
;	cmp al,07h
;jne but3
;jmp main
;--------------------------subroutines--------------------------
; Ends the program; pin 4
ender:
mov ah,4ch
int 21h
; Prints out the message
print:
push ax
push dx
abc:
mov dl,[si]
cmp dl,"$"
je return
mov ah,2
int 21h
inc si
jmp abc
return:
pop dx
pop ax
ret
;THIS IS WHERE YOUR CODE ENDS
code ends
end begin