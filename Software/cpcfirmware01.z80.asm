.target "z80"

/* CPC Firmware libary

   References to CPC Firmware routines

   Version 1.0 15/06/23 First Version

*/ 

/*
090   &BC0E   SCR SET MODE
      Action: Sets the screen mode
      Entry:  A contains the mode number -  it has the same value and
              characteristics as in BASIC
      Exit:   AF, BC, DE  and  HL  are  corrupt,  and  all others are
              preserved
      Notes:  The windows are set to  cover  the whole screen and the
              graphics origin is set to the bottom left corner of the
              screen; in addition, the current stream is set to zero,
              and the screen offset is zeroed
*/
ScrSetMode .equ $BC0E

/*
060   &BBB4   TXT STR SELECT
      Action: Selects a new VDU text stream
      Entry:  A contains the value of the stream to change to
      Exit:   A contains the previously  selected  stream, HL and the
              flags are corrupt, and all others are preserved
*/
TxtStrSelect .equ $BBB4

/* Firmware Call TXT STR SELECT
    Entry: A contains the value of the stream to change to
    Exit: HL is preserved
*/
FwTxtStrSelect:
    push hl
    call TxtStrSelect
    pop hl
    ret

/*
034   &BB66   TXT WIN ENABLE

      Action: Sets the boundaries of the  current  text window - uses
              physical coordinates
      Entry:  H hoIds the column  number  of  one  edge,  D holds the
              column number of  the  other  edge,  L  holds  the line
              number of one edge, and E  holds the line number of the
              other edge Exit: AF, BC, DE and HL are corrupt
      Notes:  The window is not cleared  but  the  cursor is moved to
              the top left corner of the window
*/
TxtWinEnable .equ $BB66

/*
031   &BB5D   TXT WR CHAR
      Action: Print a character  at  the  current  cursor  position -
              control codes are printed and not obeyed
      Entry:  A contains the character to be printed
      Exit:   AF, BC, DE  and  HL  are  corrupt,  and  all others are
              preserved
      Notes:  This routine uses the TXT WRITE CHAR indirection to put
              the character on the screen
*/
TxtWrChar .equ $BB5D

/* Firmware Call TXT WR CHAR
    Entry: A contains the value of the stream to change to
    Exit: HL is preserved
*/
FwTxtWrChar:
    push hl
    call TxtWrChar
    pop hl
    ret

/*030   &BB5A   TXT OUTPUT
      Action: Output a character or control code  (&00 to &1F) to the
              screen
      Entry:  A contains the character to output
      Exit:   All registers are preserved
      Notes:  Any control codes are obeyed  and nothing is printed if
              the VDU is disabled;  characters  are printed using the
              TXT OUT  ACTION  routine;  if  using  graphics printing
              mode, then control codes are printed and not obeyed
*/
TxtOutput .equ $BB5A

/* Fimrware Call TXT OUPUT

*/
FwTxtOutput:
    call TxtOutput
    ret

/*
037   &BB6F   TXT SET COLUMN
      Action: Sets the cursor's horizontal position
      Entry:  A contains the logical column number to move the cursor
              to
      Exit:   AF and HL are corrupt, and  all the other registers are
              preserved
      Notes:  See also TXT SET CURSOR
*/
TxtSetCol .equ $BB6F

/*
038   &BB72   TXT SET ROW
      Action: Sets the cursor's vertical position
      Entry:  A contains the logical line  number  to move the cursor
              to
      Exit:   AF and HL are corrupt, and all others are preserved
      Notes:  See also TXT SET CURSOR
*/
TxtSetRow .equ $BB72

/*
039   &BB75   TXT SET CURSOR
      Action: Sets the cursor's vertical and horizontal position
      Entry:  H contains the logical column number and L contains the
              logical line number
      Exit:   AF and HL are corrupt, and all the others are preserved
      Notes:  See also TXT SET COLUMN and TXT SET ROW
*/
TxtSetCursor .equ $BB75

/*
082   &BBF6   GRA LlNE ABSOLUTE
      Action: Draws a line from the  current  graphics position to an
              absolute position, using GRA LINE
      Entry:  DE contains the user X-coordinate and HL holds the user
              Y-coordinate of the end point
      Exit:   AF, BC, DE  and  HL  are  corrupt,  and  all others are
              preserved
      Notes:  The line will be  plotted  in  the current graphics pen
              colour (may be masked  to  produce  a  dotted line on a
              6128)
*/
GraLineAbsolute .equ $BBF6

/*
064   &BBC0   GRA MOVE ABSOLUTE
      Action: Moves  the  graphics  cursor   to  an  absolute  screen
              position
      Entry:  DE contains the user X-coordinate and HL holds the user
              Y-coordinate
      Exit:   AF, BC, DE and HL are  corrupt, and all other registers
              are preserved
*/
GraMoveAbsolute .equ $BBC0

/*
008   &BB18   KM WAIT KEY
      Action: Waits for a key to be  pressed  - this routine does not
              expand any expansion tokens
      Entry:  No entry conditions
      Exit:   Carry is  true,  A  holds  the  character  or expansion
              token, and all other registers are preserved
*/
KmWaitKey .equ $BB18

/* 
Firmware call to KmWaitKey

*/
FwKmWaitKey:
    call KmWaitKey
    ret




