.model small                                   ; Define small memory model (1 code + 1 data segment)
.stack                                         ; Allocate default stack segment
.data
 msg db 10,13,"current time is $"              ; Message to display. 10,13 = newline, $ = terminator
.code
start:
 mov ax, @data                                 ; Load the address of the data segment into AX
 mov ds, ax                                     ; Initialize DS with the address in AX so we can access variables
                                               ; Display the message: "current time is"
 lea dx, msg                                    ; Load address of the message into DX
 mov ah, 9                                      ; DOS function 09h: display string at DS:DX ending with '$'
 int 21h                                        ; Call DOS interrupt
                                            ; Get the current time from system
 mov ah, 2Ch                                   ; DOS function 2Ch: get system time
 int 21h                                       ; Returns time in CH (hour), CL (minute), DH (second), DL (hundredths)
 ; Display the hour
 mov al, ch                                    ; Move hour into AL
 call disp                                     ; Call disp procedure to display 2-digit number
; Display ':'
 mov dl, ':'                                   ; Load colon character into DL
 mov ah, 2                                     ; DOS function 02h: display character in DL
 int 21h                                       ; Call DOS interrupt
 ; Display the minute
 mov al, cl                                    ; Move minute into AL
 call disp                                     ; Display minute
 ; Display ':'
 mov dl, ':'                                   ; Display another colon
 mov ah, 2                                     ; DOS function 02h: display character in DL
 int 21h                                       ; Call DOS interrupt
 ; Display the second
 mov al, dh                                    ; Move second into AL
 call disp                                     ; Display seconds
 ; Display '.'
 mov dl, '.'                                   ; Optional stylistic period
 mov ah, 2                                     ; DOS function 02h: display character in DL
 int 21h                                       ; Call DOS interrupt
 ; Terminate program and return to DOS
 mov ah, 4Ch                                   ; DOS function 4Ch: exit program
 int 21h
; --- Display Procedure: Converts binary in AL to two ASCII digits and prints them ---
disp proc near
 aam                                           ; Adjust AL to unpack BCD (e.g., 25 → AH=2, AL=5)
 add ax, 3030h                                 ; Convert AH and AL to ASCII digits by adding '0' (30h)
 mov bx, ax                                    ; Copy AX to BX
 mov dl, bh                                    ; Move high digit (tens) to DL
 mov ah, 2                                     ; DOS function 02h
 int 21h                                       ; Display first digit
 mov dl, bl                                    ; Move low digit (ones) to DL
 int 21h                                       ; Display second digit
 ret                                           ; Return from procedure
disp endp
end start                                     ; End of program; entry point is 'start'
