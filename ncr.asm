.model small            ; Use small memory model 
.stack                  ; Define default stack segment 
.data                   ; Start of data segment 
n dw 4                  ; n = 4 (can be changed) 
r dw 2                  ; r = 2 (can be changed) 
ncr dw 0                ; Result of nCr will be stored here 
msg db "ncr= $"         ; Message to display result 
.code                   ; Start of code segment 
start: 
    mov ax, @data         ; Load data segment address into AX 
    mov ds, ax            ; Set DS with the data segment address 
    mov ax, n             ; Load n into AX 
mov bx, r             
; Load r into BX 
call ncrpro          
mov ax, ncr           
mov bx, ax                          
lea dx, msg           
mov ah, 9            
int 21h               
mov ax, bx            
aam                   
mov bx, ax            
add bx, 3030h         
mov dl, bh            
mov ah, 2             
int 21h 
mov dl, bl            
int 21h               
mov ah, 4Ch           
int 21h 
; Call recursive procedure to calculate nCr 
; Move result into AX 
; Copy to BX for printing later  
; Load address of message into DX 
; DOS function to display string 
; Call DOS 
; Move nCr result into AX again for display 
; Adjust AX into unpacked BCD (AH = tens, AL = ones) 
; Store result in BX 
; Convert digits to ASCII ('0' = 30h) 
; Move high digit (tens) to DL 
; DOS function to display character 
; Move low digit (ones) to DL 
; Display it 
; Terminate program 
; ===== Recursive Procedure to Calculate nCr ===== 
; Uses Pascal's identity: 
; nCr = (n-1)Cr + (n-1)C(r-1) 
ncrpro proc near 
cmp bx, ax            
je res1               
cmp bx, 0            
je res1               
cmp bx, 1             
je resn               
dec ax                
cmp bx, ax           
; if r == n 
; then result is 1 
; if r == 0 
; then result is 1 
; if r == 1 
; then result is n 
; Calculate (n-1) 
; if r == (n-1) 
je incr              
; then result is n 
; First recursive call: (n-1)Cr 
; Save current ax and bx 
push ax              
push bx 
call ncrpro          
pop bx               
pop ax 
; Recursive call 
; Restore bx and ax 
; Second recursive call: (n-1)C(r-1) 
dec bx               
push ax 
push bx 
call ncrpro 
pop bx               
pop ax 
ret 
; r = r - 1 
; Restore registers 
; === Result cases === 
res1: 
inc ncr              
ret 
incr: 
inc ncr              
resn: 
add ncr, ax          
ret 
ncrpro endp 
end                      
; Increment result (1 added) 
; For case when r == (n - 1), result is n 
; For r == 1, result is n 
; End of program
