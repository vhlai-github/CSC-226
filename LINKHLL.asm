;-----------------------------------------------------------
;
; Program: Linkhll
;
; Function: A subroutine for a C program. This subroutine reads 4 integers and finds the product of the largest of the four. 
;
; Owner: Vincent Lai (vhlai)
;
; Date:
; 11/21/2016   Original Version
; 10/31/2018   First Version Completed. Graded 100% for functioning. 0 Points for documentation and instructions taken.
; 10/31/2018   Documentation Edits
;
;
;---------------------------------------
         .model    small               ;
         .8086                         ;
         public    _linkhll            ;
;---------------------------------------



         .data
;---------------------------------------
;
; Data Segment
;
;---------------------------------------



         .code
;---------------------------------------
;
; Code Segment
;1 = [bp+4]
;2 = [bp+6]
;3 = [bp+8]
;4 = [bp+10]
;---------------------------------------

;---------------------------------------
; Start of the subroutine. 
; Saves and sets bp. 
; Save si
;---------------------------------------
_linkhll:        ;

    push bp ;save bp
    mov bp, sp ;move bp
    push si ; saves si (i use this for addressing in the stack
    
    mov cx, 4; for loop instruction. cx also used to move around the stack

;---------------------------------------
; Start of the loop: Checks var 3 and var 4 against var 1 and 2
;---------------------------------------
again:
    mov si, cx  ;for use in indirect addresing
;---------------------------------------
; Checks against var1
;---------------------------------------
checkA:
    mov ax, word ptr[bp+si+6] ;set ax as either variable 4 or 3
    cmp ax, word ptr[bp+4] ;compare ax to var1
    jbe continue        ;if less then, go and compare ax to var2
    xchg word ptr[bp+4], ax     ;if greater than, swap ax and var1, ax is now old var1
    cmp ax, word ptr[bp+6]  ;check if old var1 was greater than var2
    jbe continue2       ;if not, check next number
    xchg word ptr[bp+6], ax     ;if so, switch old var1 and var2
    jmp continue2
;---------------------------------------
; Checks against var2
;---------------------------------------
continue:
    cmp ax, word ptr[bp+6]      ;check ax against var 2
    jbe continue2           ;if not bigger, run loop again
    xchg word ptr[bp+6], ax     ;else, swap the variables. Old var2 is now ax
    cmp ax, word ptr[bp+4]      ;check if var2 was bigger than var1
    jbe continue2               ;if not,  move on
    xchg ax, word ptr[bp+4]     ;if so, swap the numbers.
;---------------------------------------
; Decremtn cx then loops (decrements cx again)
;---------------------------------------
continue2:
    dec cx          ;runs loop again for last variable
    loop again
;---------------------------------------
; Performs the multiplication
;---------------------------------------   
    mov ax, word ptr[bp+4]  ;prepare var1 for multiplication
    mul word ptr[bp+6]  ;multiply with var2
;---------------------------------------
; Restores pointers
;---------------------------------------                                       ;
    pop si  ;restores si    
    pop bp  ;restore bp
         ret                           ; return
                                       ;
         end                           ; end source code
;---------------------------------------

