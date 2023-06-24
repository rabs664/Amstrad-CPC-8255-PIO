;  8255 PIO Test Program
;
;    Simple test program, equivalent to the PIOTST04 written in Z80 assembly and using CPC Firmware calls.
;
;    Enter Port A,B or C then = and value in hex to write to a port (i.e. A=01) and press enter
;    Program will write to ports defined as out and read from ports defined as in and display the current values
;    Enter E to exit and redurn to the Ready prompt
;
;    8255 PIO address is defined by pioaddr
;    8225 PIO Control Word is deifned by pioctrl
;
;    The program can be called by CALL &8000
;
;    Version 1.0 15/06/23 First Version
;    Version 2.0 23/06/23 Convert to use RASM
;

org #8000

jp SetupWindows

pioaddr=#F8E0           ;Address of PIO
pioaddrtext:
defb 'F8E0',#00

pioctrl=#82 ;PIO Control 
pioctrltext:
defb '82',#00

logtext:
defb '                                                                               ',#00 ;Buffer for Log Text
cmdtext:
defb '                                                                               ',#00 ;Command Input Buffer
cmdport
defb 'A' ; Port Selected by Command                                                                              

logouta:
defb 'OUT A,XX',#00
logoutb:
defb 'OUT B,XX',#00
logoutc:
defb 'OUT C,XX',#00
logoutctrl:
defb 'OUT CTRL,XX',#00

logina:
defb 'IN A,XX',#00
loginb:
defb 'IN B,XX',#00
loginc:
defb 'IN C,XX',#00

portain=0
portbin=1
portcin=0

include 'piolib02.asm'
include 'cfwlib02.asm'
include 'utilib02.asm'


;window position array
winpos1:
defb 9,2,9,24   ;window 1 Port A
winpos2:
defb 9,28,9,52  ;window 2 Port B 
winpos3:
defb 9,56,9,79  ;window 3 Port C
winpos4:
defb 4,41,4,79  ;window 4 Control
winpos5:
defb 4,2,4,37   ;window 5 Address
winpos6:
defb 14,2,14,78 ;window 6 command
winpos7:
defb 19,2,23,78 ;window 7 log
winposrowsize=4
winposrownum=7  ;window position dimension

;window titles
wintitle1: 
defb 'PORT A',#00
wintitle2:
defb 'PORT B',#00
wintitle3:
defb 'PORT C',#00
wintitle4:
defb 'CONTROL',#00
wintitle5:
defb 'ADDRESS',#00
wintitle6:
defb 'COMMAND',#00
wintitle7:
defb 'LOG',#00
wintitlerownum=7

; Print Window Titles
;
PrintWinTitle:
    ;Select window 0
    ld a,0
    call TxtStrSelect

    ;Setup the Outer Loope
    ld a, wintitlerownum
    ld iy, winpos1          ;load iy with the position of the first window
    ld ix, wintitle1        ;load iy with title of first window

PrintWinTitleOuterLoop:
    push af                 ;save the loop counter

    ;Set Cursopostion
    ld a,(iy+1)
    inc a
    call TxtSetCol
    ld a,(iy+0)
    dec a
    dec a
    call TxtSetRow
    
    PrintWinTitleInnerLoop:
        ld a,(ix+0)
        ;Check if null terminating char
        or a 
        jr z,PrintWinTitleEndInnerLoop
        call TxtWrChar
        inc ix
        jr PrintWinTitleInnerLoop


    PrintWinTitleEndInnerLoop:
    ;Point iy at next window position
    ld de, winposrowsize
    add iy,de
    ;point ix at next window title
    inc ix
    ;Check if this is the last window
    pop af
    dec a 
    or a 
    jr nz, PrintWinTitleOuterLoop

    ret

;window border coordinates
winbord1:
defw 0,240,0,296,199,296,199,240            ;window 1 border position
winbord2:
defw 208,240,208,296,423,296,423,240
winbord3:
defw 432,240,432,296,639,296,639,240
winbord4:
defw 312,320,312,376,639,376,639,320
winbord5:
defw 0,320,0,376,303,376,303,320
winbord6:
defw 0,160,0,216,639,216,639,160
winbord7:
defw 0,0,0,136,639,136,639,0
winbord:
defw winbord1, winbord2, winbord3, winbord4, winbord5, winbord6, winbord7
winbordrowsize=16           ;number of bytes in a row
winbordrownum=7             ;number of rows

;draw window borders 
;
DrawWinBord:
    ld a,2
    call ScrSetMode ;Set Mode 2

    ld a,winbordrownum
    ld ix,winbord1
DrawWinLoop:
    push af
    ld d,(ix+1)
    ld e,(ix+0)
    ld h,(ix+3)
    ld l,(ix+2)
    call GraMoveAbsolute
    ld d,(ix+5)
    ld e,(ix+4)
    ld h,(ix+7)
    ld l,(ix+6)
    call GraLineAbsolute
    ld d,(ix+9)
    ld e,(ix+8)
    ld h,(ix+11)
    ld l,(ix+10)
    call GraLineAbsolute
    ld d,(ix+13)
    ld e,(ix+12)
    ld h,(ix+15)
    ld l,(ix+14)
    call GraLineAbsolute   
    ld d,(ix+1)
    ld e,(ix+0)
    ld h,(ix+3)
    ld l,(ix+2)
    call GraLineAbsolute
    ld de,winbordrowsize
    add ix,de
    pop af
    dec a 
    jr nz,DrawWinLoop
    ret



; Create Windows
;
;
CreateWin:
    ld a,winposrownum
    ld ix,winpos1
CreateWinLoop:
    ;Save A
    push af
    ;Select window using row loop counter
    ld b,a 
    ld a,winposrownum
    sub b 
    add a,1
    call TxtStrSelect

    ld d,(ix+3)
    ld e,(ix+2)
    ld h,(ix+1)
    ld l,(ix+0)
    ;Adjust Physical and Logical Position Numbers
    dec h
    dec l 
    dec d
    dec e
    call TxtWinEnable
    ;Move to next Row
    ld de,winposrowsize
    add ix,de
    ;Check for last row
    pop af
    dec a 
    jr nz,CreateWinLoop
   ret



    

; Print PIO Address in Window 5
;
;
PrintPIOAddr:   
   ;Select window 5
    ld a,5
    call TxtStrSelect

    ld hl,pioaddrtext
    
    PrintPIOAddrLoop:
        ld a,(hl)
        ;Check if null terminating char
        or a 
        jr z,PrintPIOAddrEndLoop
        push hl
        call TxtWrChar
        pop hl
        inc hl
        jr PrintPIOAddrLoop

    PrintPIOAddrEndLoop:
   ret

; Print PIO Control in Window 4

;
PrintPIOCtrl:   
   ;Select window 4
    ld a,4
    call TxtStrSelect

    ld hl,pioctrltext
    
    PrintPIOCtrlLoop:
        ld a,(hl)
        ;Check if null terminating char
        or a 
        jr z,PrintPIOCtrlEndLoop
        push hl
        call TxtWrChar
        pop hl
        inc hl
        jr PrintPIOCtrlLoop

    PrintPIOCtrlEndLoop:
   ret

PIOPortA:
defb #F0
PIOPortB:
defb #0F
PIOPortC: 
defb #20

; Print PIO Port A Value in Window 1
;
;
PrintPIOPortA:   
   ;Select window 1
    ld a,1
    call FwTxtStrSelect

    ld a, (PIOPortA)
    call Bin2Hex
    
    ;Print Most Significant Char
    ld a,h 
    call FwTxtWrChar

    ;Print List Significant Char
    ld a,l
    call FwTxtWrChar

    ld a,#0D
    call FwTxtOutput
    ld a,#0A 
    call FwTxtOutput 

   ret

; Print PIO Port B Value in Window 2
;
;
PrintPIOPortB:   
   ;Select window 2
    ld a,2
    call FwTxtStrSelect

    ld a, (PIOPortB)
    call Bin2Hex
    
    ;Print Most Significant Char
    ld a,h 
    call FwTxtWrChar

    ;Print List Significant Char
    ld a,l 
    call FwTxtWrChar

    ld a,#0D
    call FwTxtOutput
    ld a,#0A 
    call FwTxtOutput 

   ret

; Print PIO Port C Value in Window 3
;
;
PrintPIOPortC:   
   ;Select window 3
    ld a,3
    call FwTxtStrSelect

    ld a,(PIOPortC)
    call Bin2Hex
    
    ;Print Most Significant Char
    ld a,h 
    call FwTxtWrChar

    ;Print List Significant Char
    ld a,L
    call FwTxtWrChar

    ld a,#0D
    call FwTxtOutput
    ld a,#0A 
    call FwTxtOutput 

   ret

; Initialise PIO
;
InitPIO:
    
    PIO_Def_Addr pioaddr

    ;Group A = Mode 0 (0), Port A = output (0), Port C Upper = Output (0), Group Mode = Mode 0 (0), Port B = Input (1), Port C Lower = Output (0)
    PIO_Def_CW 0,0,0,0,1,0 

    PIO_Init 

    ;put the MSB of the value written into the log text
    ld a,PIO_CW
    call Bin2Hex
    ld a,h
    ld (logoutctrl+9),a      
    ;put the LSB of the value written into the log text
    ld a,l
    ld (logoutctrl+10),a

    ld hl,logoutctrl
    call PrintLogText

    ret 


; Print Log Text to window 7
;   IN: hl = Address of Text to log
;
PrintLogText:   
   ;Select window 7
    ld a,7
    call FwTxtStrSelect

    PrintLogTextLoop:
        ld a,(hl)
        ;Check if null terminating char
        or a 
        jr z,PrintLogTextEndLoop
        call FwTxtWrChar
        inc hl
        jr PrintLogTextLoop

    PrintLogTextEndLoop:
        ld a,#0D
        call FwTxtOutput
        ld a,#0A 
        call FwTxtOutput 
   ret


; Wait for a command
;
GetCmd:
        ld hl,cmdtext           ;point HL at the input buffer
        ld a,6                  ;Select the command window
        call FwTxtStrSelect 
        ld a,">"
        call FwTxtOutput          ;Print the command prompt
   GetKey:
        ;Wait for a Key and put this in a
        call FwKmWaitKey
        ;Print the key
        call FwTxtOutput
        ;Put the key in the command buffer
        ld (hl),a 
        ;Move to next char in command buffer              
        inc hl               

        ;Wait for Enter (#0D) to be pressed
        cp #0D                  
        jr nz,GetKey            
        
        ;clear the command line
        ld a,#0A 
        call FwTxtOutput 

        ;Process command A=01 or B=01 or C=01

        ;Save first char as the port
        ld a,(cmdtext)        
        ld (cmdport),a             

        ;Convert the next two chars to a value
        ld a,(cmdtext+2)
        ld h,a        
        ld a,(cmdtext+3)
        ld l,a
        call Hex2Bin            

        ;Save the value to be written to port in e
        ld e,a

        ;Decide which port to write to
        ld a,(cmdport)
        cp "a"
        jp z,WritePortA 
        cp "A"
        jp z,WritePortA
        cp "b"
        jp z,WritePortB 
        cp "B"
        jp z,WritePortB
        cp "c"
        jp z,WritePortC 
        cp "C"
        jp z,WritePortC
        cp "e"
        jp z,EndGetCmd
        cp "E"
        jp z,EndGetCmd
        
        ;If none of these then exit
        ret

   WritePortA:
        ld a,e
        PIO_W_PA
        ;Save current value of a
        ld (PIOPortA),a

        ;put the MSB of the value written into the log text
        ld a,(cmdtext+2)
        ld (logouta+6),a      
        ;put the LSB of the value written into the log text
        ld a,(cmdtext+3)
        ld (logouta+7),a

        ld hl,logouta
        call PrintLogText
        ret
        
   WritePortB:
        ld a,e
        PIO_W_PB
        ld (PIOPortB),a

        ;put the MSB of the value written into the log text
        ld a,(cmdtext+2)
        ld (logoutb+6),a      
        ;put the LSB of the value written into the log text
        ld a,(cmdtext+3)
        ld (logoutb+7),a

        ld hl,logoutb
        call PrintLogText
        ret

   WritePortC:
        ld a,e 
        PIO_W_PC
        ld (PIOPortC),a

        ;put the MSB of the value written into the log text
        ld a,(cmdtext+2)
        ld (logoutc+6),a      
        ;put the LSB of the value written into the log text
        ld a,(cmdtext+3)
        ld (logoutc+7),a

        ld hl,logoutc
        call PrintLogText
        ret    

   EndGetCmd:
        ret

;Read Ports
;
;
ReadPorts:
        ld a,portain
        or a 
        jp z,CheckPortB 
        PIO_R_PA
        ld (PIOPortA),a 
        
        call Bin2Hex
        ld a,h
        ld (logina+5),a      
        ;put the LSB of the value written into the log text
        ld a,l
        ld (logina+6),a
        ld hl,logina
        call PrintLogText

    CheckPortB:
        ld a,portbin
        or a 
        jp z,CheckPortC 
        PIO_R_PB
        ld (PIOPOrtB),a

        call Bin2Hex
        ld a,h
        ld (loginb+5),a      
        ;put the LSB of the value written into the log text
        ld a,l
        ld (loginb+6),a
        ld hl,loginb
        call PrintLogText

    CheckPortC:
        ld a,portcin
        or a 
        jp z,EndReadPorts 
        PIO_R_PC
        ld (PIOPortC),a
       call Bin2Hex
        ld a,h
        ld (loginc+5),a      
        ;put the LSB of the value written into the log text
        ld a,l
        ld (loginc+6),a
        ld hl,loginc
        call PrintLogText

    EndReadPorts:
        ret 
         
    
SetupWindows:

    call DrawWinBord
    call PrintWinTitle
    call CreateWin
    call PrintPIOAddr
    call PrintPIOCtrl
    call InitPIO
MainLoop:
    call PrintPIOPortA
    call PrintPIOPortB 
    call PrintPIOPortC 
 
    call GetCmd
    call ReadPorts

    ;exit if E or E
    ld a,(cmdtext)
    cp a,'E'
    jp z,EndMainLoop
    cp a,'e'
    jp z,EndMainLoop

    jr MainLoop 
    
 EndMainLoop:   
        
    ret

save 'piotst02.bin',#8000,1300,DSK,'piotst02.dsk'