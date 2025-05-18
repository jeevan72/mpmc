disp macro msg
lea dx, msg        ; Load address of message into DX
mov ah, 9          ; DOS function 09h – display string
int 21h            ; Interrupt to call DOS function
endm
.model small          ; Define memory model
.stack                ; Define stack segment
.data                 ; Data segment begins
; Predefined message strings (with carriage return and line feed)
m1 db 10,13,"enter string 1:$"
m2 db 10,13,"enter string 2:$"
m3 db 10,13,"length of string 1 is:$"
m4 db 10,13,"length of string 2 is:$"
m5 db 10,13,"string1 equal to string2$"
m6 db 10,13,"string1 not equal to string2$"
; Input buffers for strings (DOS format: MaxLen, ActualLen, Data...)
str1 db 80 dup(40)
str2 db 80 dup(40)
; Variables to hold string lengths
l1 db ?
l2 db ?
.code                 ; Code segment begins
; Initialize data segment registers
mov ax, @data
mov ds, ax
mov es, ax
; Prompt user for first string
disp m1
lea dx, str1           ; Load address of str1 buffer
call read             ; Call read procedure to take input
; Prompt user for second string
disp m2
lea dx, str2          ; Load address of str2 buffer
call read             ; Call read procedure to take input
; Store the actual length of string 1
mov al, [str1+1]
mov l1, al
; Store the actual length of string 2
mov al, [str2+1]
mov l2, al
; Compare lengths of the two strings
cmp al, l1
jne strnote            ; If lengths differ, jump to not equal

; Set up for comparing strings character by character
mov ch, 0
mov cl, l1             ; Length of string to compare
lea si, str1+2         ; SI points to first char of str1
lea di, str2+2         ; DI points to first char of str2
cld                     ; Clear direction flag (increment)

repe cmpsb             ; Repeat compare while equal
jne strnote            ; If any character mismatched, not equal

; If equal
disp m5                ; Display "strings are equal"
jmp next               ; Skip to displaying lengths

strnote:                ; If strings are not equal
disp m6               ; Display "strings are not equal"
next:
; Display length of string 1
disp m3
mov al, l1
call displ             ; Call procedure to display 2-digit number
; Display length of string 2
disp m4
mov al, l2
call displ             ; Call procedure to display 2-digit number
; Exit program
mov ah, 4ch
int 21h
; === Procedure to read a string using DOS Function 0Ah ===
read proc
mov ah, 0ah            ; DOS buffered input
int 21h
ret
read endp
; === Procedure to display 2-digit decimal number ===
displ proc
aam                    ; Convert AL into two decimal digits (AH=tens, AL=units)
mov bx, ax
add bx, 3030h          ; Convert digits to ASCII
mov ah, 2
mov dl, bh             ; int 21h / AH=2 prints a single character (DL = char).
int 21h                ; Display tens digit
mov dl, bl
int 21h                ; Display units digit
ret
displ endp
end                     ; End of program
