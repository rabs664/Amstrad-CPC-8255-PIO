.target "z80"

/* Utilities Library

    Bin2hex converts a binary number to a hex string
    Hex2bin converts a hex string to a binary number

    Version 1.0 15/06/23 First Version
*/

/*Bin2hex
    Entry
        A = Binary Number
    Exit    
        H = Most Significant Char
        L = Least Significant Char
*/
Bin2Hex:
    ld b,a 
    and $F0 
    rrca
    rrca 
    rrca
    rrca
    call Nascii
    ld h,a 
    ld a,B
    and $F 
    call Nascii 
    ld l,A
    ret

Nascii:
    cp 10
    jr c,Nas1
    add a,7

Nas1:
    add a,"0"
    ret    


/* Hex2Bin
   Entry 
            H = Most Significant Char
            L = Least Significant Char
   Exit
            A = Binary number       
*/
Hex2bin:
    ld a,L
    call A2Hex
    ld b,a 
    ld a,h 
    call A2Hex
    rrca
    rrca
    rrca
    rrca
    or b 
    ret 

A2Hex:
    sub "0"     
    cp 10
    jr c,A2Hex1
    sub 7
A2Hex1:
    ret      