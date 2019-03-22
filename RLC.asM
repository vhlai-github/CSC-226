;---------------------------------------------------------------------
;  Program:      Run Length Coding
;
;  Function:     Decompresses 1 dimensional run lengths
;                This subroutine links with a C main program
;
;                Add your additional functional comments
;
;  Owner:       Vincent Lai
;
;  Changes:
;  Date          Reason
;  ----          ------
;  05/16/2017    Original version ... coded to spec design
;  11/15/2018    First complete version. 
;---------------------------------------------------------------------
         .model    small
         .8086
         public    _rlc
;---------------------------------------
         .data                         ;start the data segment
              
;---------------------------------------



;    Your data goes here
    currColor   db  20h             ;stores the current color to be printed
    dataSeg     dw  0000
    counter     db  01h


;---------------------------------------
         .code                         ;start the code segnment
;---------------------------------------
; Save the registers ... 'C' requires (bp,si,di)
; Access the input and output lists
;---------------------------------------
_rlc:                                  ;
         push      bp                  ;save 'C' register
         mov       bp,sp               ;set bp to point to stack
         push      si                  ;save 'C' register
         push      di                  ;save 'C' register
         mov       si,[bp+4]           ;si points to the input compressed data
         mov       di,[bp+6]           ;di points to the empty output buffer
;---------------------------------------


; dl is a counter to check if we're on the first byte or the second byte
; al holds the value to be printed (either white or black)

;---------------------------------
; start of the line
; sets the color to be printed to white
;---------------------------------

mov dl, 1
mov [dataSeg], ds

startLine: 
    mov bx, 80                ;sets char/line counter to 80
    mov [currColor], 20h      ;sets first color to white
    jmp cont

;---------------------------------
; loads the next byte to be read. 
; Uses the stack to store them so that
; they can be retrieved in reverse order
; This is also done so they can be loaded
; into the cx register
;---------------------------------
loadByte:  
    cld             ;clear direction flag
    lodsb           ;al holds whole byte
    cmp al, 0       ;check if the byte is just 0
    je exit         ;if it reads a 0 for the whole byte, the program will exit
    
    mov ah, 0       ;store al as a word
    mov dx, ax      ;store al for a second comparison
    and ax, 000fh   ;mask to get lower bits, then push onto stack
    push ax         ;push lower bits onto the stack
    mov cl, 4       ;needed for shr instruction
    shr dx, cl      ;shr to get higher bits, then push onto stack
    push dx         ;push higher bits to stack
    
    mov dl, 0       ;set low/high counter to 0

;---------------------------------
; Checks the next 4 bits to see if it
; needs to print to the end of the line
;---------------------------------   
check:
    pop cx              ;pop from the stack
    cmp cx, 000fh       ;if the 4 bits is an F, print to the end of the line
    je  goToEnd         ;print to the end
;---------------------------------
; Stores the current color character
; based on the inputted number of bits
;---------------------------------     
store:              
    sub bx, cx      ;update the line counter
    mov es, dataSeg      ;set up step for stosb
    mov al, [currColor] ;gets the current color
    cld             ;clear direction variable
    rep stosb       ;print
;---------------------------------
; If then statement to switch the colors
;--------------------------------- 
switchColor:
    cmp al, 20h        ;check color
    jne switchWhite    ;if black, change to white
    mov [currColor], 219    ;if white, change to black
    jmp cont            ;increment dl
switchWhite:
    mov [currColor], 20h    ;change to white
;---------------------------------
; Checks if both set of 4 bits from a byte has been read
;--------------------------------- 
cont:           
    inc dl          ; checks if two half bytes have been read
    cmp dl, 2       ;  
    je  loadByte    ;if so, load the next byte form the stack
    jmp check       ;if not, go back to check, which will pop second readable 4 bits
       
;---------------------------------
; Prints the current color to the end of the line
;---------------------------------       
goToEnd:
    mov cx, bx          ; loops until end of line
    cld                 ;clear direction flag
    mov es, dataSeg          ;set es to ds
    mov al, currColor   ;gets the current color
    rep stosb               ;store the current character
    jmp startLine        ;will check if 2 half bytes have been read 
    

    





;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:                                  ;
         pop       di                  ;restore 'C' register
         pop       si                  ;restore 'C' register
         pop       bp                  ;restore 'C' register
         ret                           ;return
;---------------------------------------
         end

