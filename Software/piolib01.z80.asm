.target "z80"

/*
    PIO_Set_Addr(Addr) Setups the Address for the Port A, B, C and the Control Regeister
    PIO_Set_Cw(GA,PA,PCU,GB,PB,PCL) Sets the Control Word
    PIO_Init() Writes the Control Word
    PIO_W_PA() Wites Register A to Port A
    PIO_W_PB() Wites Register A to Port B
    PIO_W_PC() Wites Register A to Port C
    PIO_R_PA() Reads Port A into Register A
    PIO_R_PB() Reads Port B into Regsiter A
    PIO_R_PC() Reads Port C into Regsiter A
*/

PIO_PA .var $3E80
PIO_PB .var PIO_PA + 1
PIO_PC .var PIO_PB + 1
PIO_CR .var PIO_PC + 1

PIO_CW .var $80

/* PIO_Set_Addr
    In : Addr

    Sets the adress of PIO Ports and Control Register
*/
.macro PIO_Set_Addr(Addr=$3E80)

    PIO_PA = Addr           // Port A Address
    PIO_PB = PIO_PA + 1     // Port B Address
    PIO_PC = PIO_PB + 1     // Port C Address
    PIO_CR = PIO_PC + 1     // Control Register Address
    
    .print "PIO PA", PIO_PA
    .print "PIO PB", PIO_PB
    .print "PIO PC", PIO_PC
    .print "PIO CR", PIO_CR
.endmacro

/* PIO_Set_CW

    Description: Defines the PIO Control Word

    IN:
        GA  = Group A Mode (0,1,2) 
        PA  = Port A (0,1)
        PCU = Port C Upper (0,1)
        GB  = Group B Mode (0,1)
        PB  = Port B (0,1)
        PCL = Port C Lower (0,1)

*/
.macro PIO_Set_CW(GA=0,PA=0,PCU=0,GB=0,PB=1,PCL=0)

    // Active   = bit  7
    // GA       = bits 6 and 5
    // PA       = bit  4
    // PCU      = bit  3
    // GB       = bit  2
    // PB       = bit  1
    // PCL      = bit  0

    PIO_CW = $80 + (GA << 5) + (PA << 4) + (PCU << 3) + (GB << 2) + (PB << 1) + PCL

    .print "PIO CW",PIO_CW 

.endmacro

/* PIO_Init

    Description: Initialise the PIO by writing the Control Word to the Control Regsister

    IN: None

*/
.macro PIO_Init()

    LD BC,PIO_CR
    LD A,PIO_CW
    OUT (C),A
    
.endmacro

/* PIO_W_PA

    Description: Write Regsiter A to Port A

    IN: A

*/
.macro PIO_W_PA()

    LD BC,PIO_PA
    OUT (C),A

.endmacro

/* PIO_W_PB

    Description: Write Regsiter A to Port B

    IN: A

*/
.macro PIO_W_PB()

    LD BC,PIO_PB
    OUT (C),A

.endmacro

/* PIO_W_PC

    Description: Write Regsiter A to Port C

    IN: A

*/
.macro PIO_W_PC()

    LD BC,PIO_PC
    OUT (C),A

.endmacro

/* PIO_R_PA

    Description: Read Port A and load Regsister A

    OUT: A

*/
.macro PIO_R_PA()

    LD BC,PIO_PA
    IN A,(C)
    
.endmacro

/* PIO_R_PB

    Description: Read Port B load Regsister A

    OUT: A

*/
.macro PIO_R_PB()

    LD BC,PIO_PB
    IN A,(C)
    
.endmacro

/* PIO_R_PC

    Description: Read Port C load Regsister A

    OUT: A

*/
.macro PIO_R_PC()

    LD BC,PIO_PC
    IN A,(C)
    
.endmacro