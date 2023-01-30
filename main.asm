code segment
	mov si,0h			; si register is used to control whether last input is operation or number. If it is 0h last input is operation, if it is 01h last input is number
	temp db 0d			; temp variable will be used to check input is an expression or just one hexadecimal number
	number db 5 dup 48		; number variable is a 5 bit string that will keep the result that will be printed
	cr dw 10,13,"$"			; cr variable will be used in print_cr label that print new line before the output
	jmp take_input			; jumps to take_input
letter:					; letter label is used to convert string input letter to numeric hexadecimal letter value and adds to last sum value to create new sum
	sub al,'7'			
	mov cx,0h
  	mov cl,al 
  	mov ax,10h
  	mul bx  
  	add cx,ax 
  	mov bx,cx
  	jmp take_input			; jumps to take_input
digit:					; digit label is used to convert string input digit to numeric hexadecimal digit value and adds to last sum value to create new sum
	sub al,'0'
	mov cx,0h
  	mov cl,al 
  	mov ax,10h
  	mul bx  
  	add cx,ax 
  	mov bx,cx
  	jmp take_input			; jumps to take_input
adding:					; adding label is used to add two number from the top of the stack and push the result
	add temp,1d
	mov si,0h
	pop ax
	pop cx
	add ax,cx
	mov cx,0h
	push ax
	jmp take_input			; jumps to take_input
multiple:				; multiple label is used to multiply two number from the top of the stack and push the result
	add temp,1d
	mov si,0h
	pop ax
	pop cx
	mul cx
	mov cx,0h
	push ax
	jmp take_input			; jumps to take_input
division:				; division label is used to divide two number from the top of the stack and push the result
	add temp,1d
	mov si,0h
	pop cx
	pop ax
	div cx
	mov cx,0h
	push ax
	jmp take_input			; jumps to take_input
xorxor:					; xor xor label is used to xor two number from the top of the stack and push the result
	add temp,1d
	mov si,0h
	pop ax
	pop cx
	xor ax,cx
	mov cx,0h
	push ax
	jmp take_input			; jumps to take_input	
oror:					; oror label is used to or two number from the top of the stack and push the result
	add temp,1d
	mov si,0h
	pop ax
	pop cx
	or ax,cx
	mov cx,0h
	push ax
	jmp take_input			; jumps to take_input
andand:					; andand label is used to and two number from the top of the stack and push the result
	add temp,1d
	mov si,0h
	pop ax
	pop cx
	and ax,cx
	mov cx,0h
	push ax
	jmp take_input			; jumps to take_input
dummylabel:				; dummylabel label is used to jump to take_input
	jmp take_input
dummylabel2:				; dummylabel2 label is used to jump to return_stack
	jmp return_stack
dummylabel3:				; dummylabel3 label is used to jump to letter
	jmp letter
dummylabel4:				; dummylabel4 label is used to jump to adding
	jmp adding
dummylabel5:				; dummylabel5 label is used to jump to multiple
	jmp multiple
space:					; space label is used when input is space, if last input before space is number, it pushes that number, else jump dummylabel
	cmp si, 0h			; compare si is 0h or 01h
 	je dummylabel			; jumps to dummylabel
 	push bx
 	mov bx,0h

take_input:				; take_input label takes input char by char and controls it
	mov ah,01h			; take input interrupt	
	int 21h									
	cmp al,0Dh			; if input is enter jumps to dummylabel2	
	je dummylabel2
	cmp al, 20h			; if input is space jumps to space
	je space
	cmp al, '+'			; if input is "+" jumps to dummylabel4
	je dummylabel4
	cmp al, '*'			; if input is "*" jumps to dummylabel5
	je dummylabel5
	cmp al, '/'			; if input is "/" jumps to division
	je division
	cmp al, '^'			; if input is "^" jumps to xorxor
	je xorxor
	cmp al, '&'			; if input is "&" jumps to andand
	je andand
	cmp al,'|'			; if input is "|" jumps to oror			
	je oror
	mov si,01h
	cmp al,'@'			; if input is greater than "@" jumps to dummylabel3
	jg dummylabel3
	jmp digit			; jumps to digit
return_stack:				; return_stack label is used to finish taking input part and jumps to setup_string
	cmp temp,0d			; if input is just one number directly jump to setup_string if not first pop the result then jump to setup_string
	je setup_string
	pop bx
	jmp setup_string
convert_letter:				; convert_letter label is used to convert numeric hexadecimal letter value to char letter value and add to our number variable
	add dx,55d
	mov [bx],dl
	dec bx
	cmp ax,00			; if it is last digit jump to print_cr if not jump to convert_hexa
	je print_cr			
	jmp convert_hexa
setup_string:				; setup_string label is used to setup our string to print by adding "$" end of it
	mov ax,bx
	mov bx, offset number+4
	mov b[bx],"$"
	dec bx
convert_hexa:				; convert_hexa label is used to convert our hexadecimal numeric result to string
	mov dx,0
	mov cx,10h
	div cx				; this divides number 10h
	cmp dx,09h			; if remainder part is greater than 09h it is letter so jump to convert_letter
	jg convert_letter
	add dx,48d			; if it is digit not letter convert string value by adding 48d to it
	mov [bx],dl
	dec bx
	cmp ax,00			; if it is last digit jump to print_cr if not jump to convert_hexa
	je print_cr
	jmp convert_hexa
print_cr:				; print_cr label is used to print carriage return before print the result
	mov ah,09
	mov dx,offset cr
	int 21h
printout:				; printout label is used to print the result
	mov dx,offset number
	mov ah,09
	int 21h
exit:					; exit label is used to terminate the program
	mov ah,04ch
	mov al,00
	int 21h
code ends
