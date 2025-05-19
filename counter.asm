.model small                      ; Use the small memory model (code and data fit in one segment)  
.stack                           ; Define the stack segment (default size) 
.data                             ; Start of data segment 
msg db "press any key to exit$"   ; Message to display on screen 
.code                             ; Start of code segment 
start: 
    mov ax, @data         ; Load address of data segment into AX 
    mov ds, ax            ; Initialize DS with data segment address 
    call clear            ; Clear the screen 
    lea dx, msg           ; Load the address of the message into DX 
    mov ah, 9             ; DOS function to print string 
    int 21h               ; Call DOS to print message 
    mov ax, 00h           ; Initialize AX with 0, used as a counter 
nxtnum: 
    push ax               ; Save current count value on stack (to preserve across subroutines) 
    call setcursor        ; Set the cursor position (row=12, col=40) 
    call disp             ; Display the current value in AX 
    call delay            ; Delay so it doesn't count too fast 
    mov ah, 01h           ; Check for key press (non-blocking) 
    int 16h               ; BIOS interrupt 
    jnz exit              ; If a key was pressed, jump to exit 
    pop ax                ; Restore the previous AX value from the stack 
    add ax, 1             ; Increment the counter 
    daa                   ; Decimal Adjust AL (optional for BCD representation) 
    cmp ax, 0             ; Loop always unless overflowed to 0 (unlikely) 
    jnz nxtnum            ; Repeat loop 
exit: 
    mov ah, 4Ch           ; DOS function to terminate program 
    int 21h               ; Return control to DOS 
; setcursor: Moves the cursor to row 12, column 40 
setcursor proc 
    mov ah, 2              ; BIOS function to set cursor position 
    mov dh, 12             ; Row 12 
    mov dl, 40             ; Column 40 
    int 10h                ; BIOS video interrupt 
    ret 
setcursor endp  ;       disp: Displays the 2-digit number in AL 
; Converts the number in AL to ASCII and prints it
; The number is displayed in hexadecimal format (0x00 to 0xFF)
disp proc 
    mov bl, al             ; Save original AL value in BL 
    mov dl, al             ; Copy AL to DL for upper nibble 
    mov cl, 4              ; Prepare to shift 4 bits 
    shr dl, cl             ; Shift DL right 4 bits (upper nibble) 
    add dl, 30h            ; Convert high nibble to ASCII 
    mov ah, 2              ; DOS function to print character 
    int 21h                ; Print high digit 
    mov dl, bl             ; Get original value back 
    and dl, 0Fh            ; Mask to get low nibble 
    add dl, 30h            ; Convert to ASCII 
    int 21h                ; Print low digit 
    ret 
disp endp                  ; delay: Creates a time delay using nested loops 
delay proc 
    mov bx, 00FFh          ; Outer loop counter 
b2: 
    mov cx, 0FFFFh         ; Inner loop counter 
b1: 
    loop b1                ; Decrement CX and loop if not zero 
    dec bx                 ; Decrement BX 
    jnz b2                  ; Repeat outer loop if BX != 0 
    ret 
delay endp                ; clear: Clears the screen using BIOS scroll function 
clear proc 
    mov al, 0             ; Number of lines to scroll (0 = clear entire window) 
    mov ah, 6             ; BIOS function to scroll window up 
    mov ch, 0             ; Upper-left row = 0 
    mov cl, 0             ; Upper-left column = 0 
    mov dh, 24            ; Bottom-right row = 24 
    mov dl, 79            ; Bottom-right column = 79 
    mov bh, 7             ; Attribute (gray on black) 
    int 10h               ; BIOS video interrupt 
    ret 
clear endp 
end start                 ; Mark program end and entry point 
