    ;--------------------------
    ;Program Name: KEY
    ;Author: Vincent Lai (vhlai)
    ;Date Created: 10/1/18
    ;This program takes input from input and prints them out. Upon reading
    ;a tab, the program will print spaces until it reaches the next "column" which
    ;is defaulted to 10 but may be set in the command line
    ;--------------------------
    
    ;-----------------------------
    ;Specifications
    ; No prompts or error messages
    ; No return code
    ; Program should be able to read any available keyboard input.
    ; Uses a counter that is set to the column size, and decremented per character printed.
    ; When counter hits 0, the counter is reset
    ;----------------------------
    
    ;--------------------
    ;Updates List
    ; 10/15 12:00 Original Submission. Everything functional upon grading. 
    ; 20 Points for Efficiency (29 instructions) 0 Points for documentation
    ; 10/15 12:15 Documentation updates. Added program header and updates list. 
    ; Renamed clp to read
    ; 10/15 12:20 Changed documentation for clarity
    ;----------------------

.model  small   ;64k code and 64k data
.8086           ;only allow 8086 commands

.data           ;start of data segment

.code   ;start of code segment

    ;---------------------------------------------;
    ;Checks for command line argument for tab size;
    ;Sets "reset" value to input if available     ;
    ;---------------------------------------------;
start:
    cmp byte ptr es:[80h], 0    ;access the CLP count 80h bytes into the extra segment
    je noclp                    ;no parameter...continue with the program
    mov cl, byte ptr es:[82h]   ;parameter entered...load cl with the CLP character. cl is the counter reset value
    add cl, -48                 ;converts ascii value to actual integer value
    jmp setcolumn               ;set the counter for printed characters
    
    ;---------------------------------------;
    ;If no command line argument was read   ;
    ;Sets reset value to default value of 10;
    ;---------------------------------------;      
noclp:
    mov cl, 10  ;set reset value to 10 (column default size default)
    jmp setcolumn   ;set the column size
    ;----------------;
    ;reads the input ;
    ;prepare to write;
    ;----------------; 
read:
    mov ah,8    ; read without echo
    int 21h     ; execute read
    mov ah,2    ; code to write character (prepare)   
    mov dl, al  ; mov character to dl
    ;-------------------------------------------;
    ;checks for tab character                   ;
    ;if tab is read, set output value to a space;
    ;-------------------------------------------; 
tabcheck:
    cmp al, 9   ;check for tab character
    mov dl, 32    ;if tab character, go to print tab
    ;---------------------------;
    ;prints the output character;
    ;---------------------------; 
print:    
    int 21h     ; write character
    
    ;-----------------------------------------;
    ;checks end of line or end of file        ;
    ;if EOF read, exit program                ;
    ;if end of line read, reset column counter;
    ;-----------------------------------------; 
check2:    
    cmp al, 1Ah     ;check for EOF
    je  exit    ;exit
    cmp al, 0Ah ;check for end of line
    je  setcolumn  ;reset column counter

    ;------------------------------------------------;
    ;subtract 1 from counter then checks if          ;
    ;more spaces need to be printed for tab character;
    ;------------------------------------------------;     
subtract:
    add bl, -1   ;subtract 1 from counter
    cmp bl, 0   ;check for column end
    je  setcolumn   ;go to reset column
    cmp al, 9   ;checks for tab character
    je tabcheck ;prepares to reprint a space
    jmp read     ;read next input
    
    ;---------------------;
    ;resets column counter;
    ;---------------------; 
setcolumn:
    mov bl, cl  ;resets columnsize
    jmp read ;go back to read character
  
exit: ;exits the program
    mov ax, 4c00h   ;code for terminate program
    int 21h;        ;end program
    end start;      ;program starts at label start
    