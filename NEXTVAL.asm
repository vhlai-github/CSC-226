;---------------------------------------------------------------------
; Program:   nextval subroutine
;
; Function:  Find next mouse move in an array 15 by 30.
;            We can move into a position if its contents is blank ( 20h ).
;
; Input:     Calling sequence is:
;            x    pointer   si
;            y    pointer   di
;            dir  pointer   bx
;            maze pointer   bp
;
; Output:    x,y,dir modified in caller's data segment
;
; Owner:     Dana A. Lasher 
; Edited by: Vincent Lai
;
; Date:      Update Reason
; --------------------------
; 11/06/2016 Original version
; 10/24/2018 First version: 44 instructions. 0 POints for instructions executed. 
; 10/24/2018 Second version: 41 instructions. 0 Points instructions executed. 
; 10/24/2018 Documentation added
;
;---------------------------------------
         .model    small               ;64k code and 64k data
         .8086                         ;only allow 8086 instructions
         public    nextval             ;allow extrnal programs to call
;---------------------------------------


;---------------------------------------
         .data                         ;start the data segment
;---------------------------------------


;---------------------------------------
         .code                         ;start the code segment
;---------------------------------------
; Save any modified registers
;---------------------------------------
nextval:        ;

    push ax     ;ax used for mul
    push dx     ;used to store 
    push bp     ;bp edited for comparison purposes
                      ;
;---------------------------------------
; Code to make 1 move in the maze
;---------------------------------------

;---------------------------------------
; Calculates the offset and changes bp
; for comparisons
;---------------------------------------
calculateOffset:   
    mov al, 30    ;use al for mul later
    mul byte ptr [di]          ;perform mul (y-1)*30
    mov dl, [si]    ;set dl as x
    mov dh, 0       ;convert byte to word
    add ax, dx      ;offset+x
    add bp, ax      ;set bp
    
    
;---------------------------------------
; Check the starting direction of the mouse
;--------------------------------------- 
checkDirection:    
    cmp byte ptr [bx], 1    ;if east
    je testn                ;try north
    cmp byte ptr [bx], 2    ;if south
    je teste                ;try east
    cmp byte ptr [bx], 3    ;if west
    je tests                ;try south
    
    ;check north is a fallthroguh to test west
;---------------------------------------
; Test commands for each case
; Checks for the next direction are fall throughs
;---------------------------------------    
;---------------------------------------
; Test West
;---------------------------------------
testw: 
    cmp byte ptr ds:[bp-32], 20h ;checks the space to the west
    je moveW                    ;if free move west
;---------------------------------------
; Test North
;---------------------------------------   
testn: 
    cmp byte ptr ds:[bp-61], 20h    ;checks space to the north
    je moveN                        ;if free move north
;---------------------------------------
; Test East
;---------------------------------------    
teste: 
    cmp byte ptr ds:[bp-30], 20h     ;checks space to the east
    je moveE                        ;if free move east
;---------------------------------------
; Test South
;---------------------------------------
tests: 
    cmp byte ptr ds:[bp-1], 20h    ;fhecks space to the south
    jne testw                       ;if not free, check west
    ;moveS is a fall through

;---------------------------------------
; Individual Move Commands 
;---------------------------------------
;---------------------------------------
; Move South
;---------------------------------------
moveS:
    mov byte ptr [bx], 2        ;sets mouse direction to south
    inc byte ptr [di]           ;increases y coordinate by 1
    jmp exit                    ;exit the subtourine
;---------------------------------------
; Move East
;---------------------------------------    
moveE: 
    mov byte ptr [bx], 1        ;sets mouse direction to east
    inc byte ptr [si]           ;increases x coordinate by 1
    jmp exit                    ;exit the subroutine
;---------------------------------------
; Move West
;---------------------------------------    
moveW: 
    mov byte ptr [bx], 3        ;sets mouse direction to west
    dec byte ptr [si]           ;decrease x coordinate by 1
    jmp exit                    ;exit the subroutine
;---------------------------------------
; Move North
;---------------------------------------    
moveN: 
    mov byte ptr [bx], 4        ;sets mouse direction to north
    dec byte ptr [di]           ;decrease y coordinate by 1
                                       ;
                                       ;
                                       ;
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:      ;
    pop bp;
    pop dx
    pop ax
                                       ;
         ret                           ;return
;---------------------------------------
         end
