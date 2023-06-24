;    PIO library
;
;    PIO_Set_Addr(Addr) Setups the Address for the Port A, B, C and the Control Regeister
;    PIO_Set_CW GA,PA,PCU,GB,PB,PCL Sets the Control Word
;    PIO_Init Writes the Control Word
;    PIO_W_PA Wites Register A to Port A
;    PIO_W_PB Wites Register A to Port B
;    PIO_W_PC Wites Register A to Port C
;    PIO_R_PA Reads Port A into Register A
;    PIO_R_PB Reads Port B into Regsiter A
;    PIO_R_PC Reads Port C into Regsiter A
;
;    Version 1.0 15/06/23 First Version
;    Version 2.0 23/06/23 Change to use RASM
;

PIO_PA=#3E80
PIO_PB=PIO_PA+1
PIO_PC=PIO_PB+1
PIO_CR=PIO_PC+1

PIO_CW=#80

; PIO_Def_Addr
;    In : Addr
;
;    Sets the adress of PIO Ports and Control Register
;
macro PIO_Def_Addr Addr

    PIO_PA={Addr}       ; Port A Address
    PIO_PB=PIO_PA+1     ; Port B Address
    PIO_PC=PIO_PB+1     ; Port C Address
    PIO_CR=PIO_PC+1     ; Control Register Address
    
    print 'PIO PA', {hex4}PIO_PA
    print 'PIO PB', {hex4}PIO_PB
    print 'PIO PC', {hex4}PIO_PC
    print 'PIO CR', {hex4}PIO_CR
mend

; PIO_Def_CW
;
;    Description: Defines the PIO Control Word
;
;    IN:
;        GA  = Group A Mode (0,1,2) 
;        PA  = Port A (0,1)
;        PCU = Port C Upper (0,1)
;        GB  = Group B Mode (0,1)
;        PB  = Port B (0,1)
;        PCL = Port C Lower (0,1)
;
;
macro PIO_Def_CW GA,PA,PCU,GB,PB,PCL
;
;    Active   = bit  7
;    GA       = bits 6 and 5
;    PA       = bit  4
;    PCU      = bit  3
;    GB       = bit  2
;    PB       = bit  1
;    PCL      = bit  0
;
    PIO_CW = $80 + ({GA} << 5) + ({PA} << 4) + ({PCU} << 3) + ({GB} << 2) + ({PB} << 1) + {PCL}

    print 'PIO CW',{hex2}PIO_CW 

mend

; PIO_Init
;
;    Description: Initialise the PIO by writing the Control Word to the Control Regsister
;
;    IN: None
;
;
macro PIO_Init

    ld bc,PIO_CR
    ld a,PIO_CW
    out (c),a
    
mend

; PIO_W_PA
;
;    Description: Write Regsiter A to Port A
;
;    IN: A
;
;
macro PIO_W_PA

    ld bc,PIO_PA
    out (c),a

mend

; PIO_W_PB
;
;    Description: Write Regsiter A to Port B
;
;    IN: A
;
;
macro PIO_W_PB
    ld bc,PIO_PB
    out (c),a

mend

; PIO_W_PC
;
;    Description: Write Regsiter A to Port C
;
;    IN: A
;
;
macro PIO_W_PC

    ld bc,PIO_PC
    out (c),a

mend

; PIO_R_PA
;
;    Description: Read Port A and load Regsister A
;
;    OUT: A
;
;
macro PIO_R_PA

    ld bc,PIO_PA
    in a,(c)
    
mend

; PIO_R_PB
;
;    Description: Read Port B load Regsister A
;
;    OUT: A
;
;
macro PIO_R_PB

    ld bc,PIO_PB
    in a,(c)
    
mend

; PIO_R_PC
;
;    Description: Read Port C load Regsister A
;
;    OUT: A
;
;
macro PIO_R_PC

    ld bc,PIO_PC
    in a,(c)
    
mend