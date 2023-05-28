.target "z80"

//********************************************************************
//; Output Test: 8255 Centurion Laser Eyes 
//; Address bus line A4 sets starting address to binary 0001 0000, hex 0x10, decimal 16.
//********************************************************************
PortA	.EQU	$F838		// Port A address.
PortB	.EQU	$F839		// Port B address.
PortC	.EQU	$F83A  	// Port C address.
CWR	.EQU	$F83B   	// Control Word Register.
CWRCfg	.EQU	$80		// Configuration word: Active, Mode 0, A & B & C outputs.

.ORG	$0000

	NOP             // Safety filler NOP.
	LD A,$80		// Set CWR so all ports are output.
    LD BC,$F83B
	OUT (C),A 	// Send control word 0x80 to CWR.

    LD A,$1         // D0 bit selected.
    LD BC,$F838
    OUT (C),A  // Output the bit on the databus to the 8255.

    HALT
.END