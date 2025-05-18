.model small          ; Use small memory model
.stack 100              
.data                    
; Use small memory model (single code & data segment) 
; Reserve 100 bytes for stack 
; Data segment 
    a db 10,6,8,0,4,2     ; Array of 6 elements to sort 
    len dw ($ - a)        ; Calculate length of array (6 bytes here) 
.code                    ; Start of code segment 
start: 
    mov ax, @data        ; Load data segment address into AX 
    mov ds, ax            ; Initialize DS with data segment address 
    mov bx, len           ; Load length of array into BX (BX = 6) 
    dec bx                ; BX = len - 1 = 5 (number of outer loop passes) 
outloop:                  ; Outer loop for Bubble Sort (5 passes needed for 6 elements) 
    mov cx, bx            ; CX = number of inner loop iterations (decreases each pass) 
    mov si, 0             ; SI = index into array (starting at 0) 
inloop:                  
    mov al, a[si]         ; Load current element into AL 
    cmp al, a[si+1]       ; Compare AL with next element 
    jb next               ; If AL < next element, skip swap (already in correct order) 
    ; Swap a[si] and a[si+1] 
    xchg al, a[si+1]      ; Exchange AL with a[si+1] 
    mov a[si], al         ; Store the original a[si+1] into a[si] 
next: 
    inc si                ; Move to next index 
    loop inloop           ; Decrease CX and repeat inner loop if CX != 0 
    dec bx                ; Decrement outer loop counter 
    jnz outloop           ; Repeat outer loop if BX != 0 
    ; End of program 
    mov ah, 4Ch           ; Terminate program 
    int 21h 
end start                  ; End of code, entry point is "start" 
