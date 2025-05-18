.model small          ; Use small memory model
.stack                ; Define default stack segment
.data                 ; Start of data segment
n dw 4                 ; n = 4 (can be changed)
r dw 2                 ; r = 2 (can be changed)
ncr dw 0               ; Result of nCr will be stored here
msg db "ncr= $"        ; Message to display result
.code                 ; Start of code segment
start:
 mov ax, @data        ; Load data segment address into AX
 mov ds, ax           ; Set DS with the data segment address
 mov ax, n            ; Load n into AX
 mov bx, r            ; Load r into BX
 call ncrpro         ; Call recursive procedure to calculate nCr
 mov ax, ncr         ; Move result into AX
 mov bx, ax          ; Copy to BX for printing later
 lea dx, msg        ; Load address of message into DX
 mov ah, 9          ; DOS function to display string
 int 21h            ; Call DOS
 mov ax, bx         ; Move nCr result into AX again for display
 aam                 ; Adjust AX into unpacked BCD (AH = tens, AL = ones)
 mov bx, ax         ; Store result in BX
 add bx, 3030h     ; Convert digits to ASCII ('0' = 30h)
 mov dl, bh        ; Move high digit (tens) to DL
 mov ah, 2         ; DOS function to display character
 int 21h
 mov dl, bl       ; Move low digit (ones) to DL
 int 21h         ; Display it
 mov ah, 4Ch     ; Terminate program
 int 21h
; ===== Recursive Procedure to Calculate nCr =====
; Uses Pascal's identity:
; nCr = (n-1)Cr + (n-1)C(r-1)
ncrpro proc near
 cmp bx, ax                 ; if r == n
 je res1                     ; then result is 1
 cmp bx, 0                   ; if r == 0
 je res1                     ; then result is 1
 cmp bx, 1                   ; if r == 1
 je resn                     ; then result is n
 dec ax                      ; Calculate (n-1)
 cmp bx, ax                  ; if r == (n-1)
 je incr                     ; then result is n
 ; First recursive call: (n-1)Cr
 push ax                     ; Save current ax and bx
 push bx
 call ncrpro                 ; Recursive call
 pop bx                      ; Restore bx and ax
 pop ax
 ; Second recursive call: (n-1)C(r-1)
 dec bx ; r = r - 1
 push ax
 push bx
 call ncrpro
 pop bx ; Restore registers
 pop ax
 ret
; === Result cases ===
res1:
 inc ncr ; Increment result (1 added)
 ret
incr:
 inc ncr ; For case when r == (n - 1), result is n
resn:
 add ncr, ax ; For r == 1, result is n
 ret
ncrpro endp
end ; End of program
