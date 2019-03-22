    ;--------------------------
    ;Program Name: KEY
    ;Author: Vincent Lai (vhlai)
    ;Date Created: 10/1/18
    ;This program reads input from the keyboard, printing Uppercase letters
    ;replacing lowercase letters with uppercase letters, and printing spaces. 
    ;Upon reading a period, it will print the period and terminate the program.
    ;--------------------------
    
    ;-----------------------------
    ;Specifications
    ; No prompts or error messages
    ; No return code
    ; Program not built to handle special characters 
    ; Can handle symbols such as !, @, # (will not print)
    ;----------------------------
    
    ;--------------------
    ;Updates List
    ; 10/1 12:00 Original Submission. Everything functional upon grading. 0 Points for documentation
    ; 10/1 19:00 Documentation updates. Added program header and updates list. 
    ;----------------------


.model  small   ;64k code and 64k data
.8086           ;only allow 8086 commands

.data           ;start of data segment

    ;-----------------------------------------------------;
    ;translation table for xlat, all non valid characters ;
    ;are replaced with asteriks which will be ignored when;
    ;deciding whether or not to print the typed character ;
    ;-----------------------------------------------------;
tran    db  '**********' ;input characters, 000-009
        db  '**********' ;input characters, 000-009
        db  '**********' ;input characters, 000-009
        db  '** *******' ;input characters, 030-039. Note character 32 is a space
        db  '******.***' ;input characters, 040-049. Note character 46 is a period
        db  '**********' ;input characters, 050-059
        db  '*****ABCDE' ;input characters, 060-069. Alphabet starts at 65
        db  'FGHIJKLMNO' ;input characters, 070-079
        db  'PQRSTUVWXY' ;input characters, 080-089
        db  'Z******ABC' ;input characters, 090-099. Uppercase ends at 90, lowercase starts at 97
        db  'DEFGHIJKLM' ;input characters, 100-110
        db  'NOPQRSTUVW' ;input characters, 111-119
        db  'XYZ'           ;input characters, 120-122
        db  133 dup ('*')   ;all remaining input characters

.code   ;start of code segment
    ;-------------------------------------------------------------;
    ;sets bx to the start ofdata segment of the start of the table;
    ;-------------------------------------------------------------;
    
start: ; start of the program
    mov ax, @data   ;set addressability
    mov ds, ax      ;to data segment
    mov bx, offset tran; bx points to table

    ;-----------------------------------------;
    ;reads character from input, one at a time;
    ;-----------------------------------------;
again:          ;will loop for every character
    mov ah,8    ; read without echo
    int 21h     ; execute read
    ;---------------------------------------------------;
    ;checks for valid character                         ;
    ;if character is valid, it will jump to print       ;
    ;otherwise, program will loop back for another input;
    ;---------------------------------------------------;
    
check: ;//gets character off table and determines whether to print or not
    xlat        ;translates character from input by table
    cmp al, 42  ;checks for character to skip (*)
    je again    ;if skippable character, read next character
    jmp print   ;if valid character, print
       
    ;---------------;
    ;print the character;
    ;---------------;
print:          ;prints the character in al
    mov ah,2    ; code to write character
    mov dl, al  ; mov character to dl
    int 21h     ; write character
    ;----------------------------------------------;
    ;checks for period                             ;
    ;If character was period, will exit the program;
    ;If not, loops to take another input           ;
    ;----------------------------------------------;
continue: ;checks for character representing end of string
    cmp al, 46      ;checks for period
    je  exit        ;if period, end
    jmp again       ;else check for next character
    ;---------------;
    ;ends the program;
    ;---------------;
exit: lexits the program
    mov ax, 4c00h   ;code for terminate program
    int 21h;        ;end program
    end start;      ;program starts at label start
    