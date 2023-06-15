10 REM ****************************************************
20 REM Basic Test Program 04 Version 1.0 15/06/23
30 REM 
40 REM Enter Port A,B or C then = and value in hex to write to a port (i.e. A=01) and press enter
50 REM Program will write to ports defined as out and read from ports defined as in and display the current values
55 REM
57 REM Base Address of 8255 is defined by pioaddr
58 REM Ctrl Byte is defined by ctrl
59 REM *****************************************************
60 MODE 2
70 GOSUB 270:'Setup globals
80 GOSUB 930:'Setup functions
90 GOSUB 1150:'Draw windows
100 GOSUB 1370:'Print Address
110 GOSUB 1310:'Print Control Word
120 GOSUB 1230:'Print Port Values
130 GOSUB 1410:'Print Port In or Out Modes
140 GOSUB 1600:'Initialise PIO
150 GOSUB 1670:'Read command line
160 GOSUB 1780:'Write to ports
170 GOSUB 1870:'Read from ports
180 GOSUB 1230:'Print Port Values
190 GOTO 150
200 END
210 '
220 REM ****************************************************
230 REM Setup globals
240 REM ****************************************************
250 '
260 REM Port IDs
270 paid=1:pbid=2:pcid=3:ctrlid=4:'Port Ids
280 '
290 REM Windows Ids
300 pawin=1:pbwin=2:pcwin=3:ctrlwin=4:addrwin=5:cmdwin=6:logwin=7:'Window Ids, match port Ids
310 '
320 REM pio base address
330 pioaddr=&F8E0
340 '
350 REM port and ctrl address
360 DIM paddr%(4):'1=pa, 2=pb, 3=pc, ctrl=4
370 FOR id=1 TO 4
380 paddr%(id)=pioaddr+(id-1)
390 NEXT id
400 '
410 REM the ctrl value
420 ctrl=&82
430 '
440 REM Mode bits positions within ctrl
450 pmodeaid=1:pmodebid=2:pmodecuid=3:pmodeclid=4
460 DIM pmodebit%(4):'pa=1, pb=2, pcu=3, pcl=4, 0 is not used
470 FOR id=1 TO 4
480 READ pmodebit%(id)
490 NEXT id
500 '
510 DATA &X00010000,&X00000010,&X00001000,&X00000001
520 '
530 pout=0:pin=1:'output and input modes
540 '
550 REM Window data
560 maxwin=7:'8 windows, 0 is the main window
570 lpoint=0:rpoint=1:tpoint=2:bpoint=3:'Window points left=0, right=1, top=2, bottom=3
580 DIM windata%(maxwin,3):'window dimensions windim(id,left|right|top|bottom), id 0 is main window
590 FOR id=1 TO maxwin
600 FOR point=lpoint TO bpoint:'left=0,right=1,top=2,bottom=3
610 READ windata%(id,point)
620 NEXT point
630 NEXT id
640 '
650 DATA 2,24,9,9:'window 1 Port A
660 DATA 28,52,9,9:'window 2 Port B 
670 DATA 56,79,9,9:'window 3 Port C
680 DATA 41,79,4,4:'window 4 Control
690 DATA 2,37,4,4:'window 5 Address
700 DATA 2,79,14,14:'window 6 command
710 DATA 2,79,19,24:'window 7 log
720 '
730 REM Window titles
740 DIM wintitle$(maxwin):'window title wintitle$(id), id 0 is main window
750 FOR id=1 TO maxwin
760 READ wintitle$(id)
770 NEXT id
780 DATA "PORT A","PORT B","PORT C","CONTROL","ADDRESS","COMMAND","LOG"
790 '
800 REM Current port data
810 DIM pdata%(3):'only 1 to 3 is used, 0 is not used
820 '
830 REM Defined Input or Output Mode for Ports in Control word
840 DIM pmode%(4):'1=pa,2=pb,3=pcu,4=pcl
850 FOR id=pmodeaid TO pmodeclid
860 IF(ctrl AND pmodebit%(id))=pmodebit%(id) THEN pmode%(id)=pin ELSE pmode%(id)=pout
870 NEXT id
880 RETURN
890 '
900 REM ****************************************************
910 REM *** Setup Functions for calculating window borders
920 REM ****************************************************
930 DEF FNx1=(640-(640-(left-1)*8))-8
940 DEF FNy1=(400-((bottom+1)*16))
950 DEF FNx2=(640-(640-(left-1)*8))-8
960 DEF FNy2=(400-((top-2)*16))+8
970 DEF FNx3=((right+1)*8)-1
980 DEF FNy3=(400-((top-2)*16)+8)
990 DEF FNx4=((right+1)*8)-1
1000 DEF FNy4=(400-((bottom+1)*16))
1010 RETURN
1020 '
1030 REM ****************************************************
1040 REM *** Draw a window (title,left,right,top,bottom)
1050 REM ****************************************************
1060 WINDOW #id,left,right,top,bottom
1070 MOVE FNx1,FNy1:DRAW FNx2,FNy2:DRAW FNx3,FNy3:DRAW FNx4,FNy4:DRAW FNx1,FNy1
1080 LOCATE left+1,top-2
1090 PRINT title$
1100 RETURN
1110 '
1120 REM ****************************************************
1130 REM *** Create Windows
1140 REM ****************************************************
1150 FOR id=pawin TO maxwin
1160 left=windata%(id,lpoint):right=windata%(id,rpoint):top=windata%(id,tpoint):bottom=windata%(id,bpoint):title$=wintitle$(id):GOSUB 1060:'draw window
1170 NEXT id
1180 RETURN
1190 '
1200 REM ****************************************************
1210 REM Print Port Data        
1220 REM ****************************************************
1230 FOR id=paid TO pcid
1240 PRINT #id,HEX$(pdata%(id),2)
1250 NEXT id
1260 RETURN
1270 '
1280 REM ****************************************************
1290 REM Print the Control Word
1300 REM ****************************************************
1310 PRINT #ctrlwin,HEX$(ctrl,2)
1320 RETURN
1330 '
1340 REM ****************************************************
1350 REM Print Address
1360 REM ****************************************************
1370 PRINT #addrwin,HEX$(pioaddr,2)
1380 RETURN
1390 '
1400 REM ****************************************************
1410 REM Print Input or Output Modes for Ports
1420 REM ****************************************************
1430 DIM titlestr$(3):'temp title string
1440 REM Ports A and B
1450 FOR id=pawin TO pbwin
1460 IF pmode%(id)=pin THEN titlestr$(id)=wintitle$(id)+" IN" ELSE titlestr$(id)=wintitle$(id)+" OUT"
1470 NEXT id
1480 REM Port C is split into upper and lower
1490 IF pmode%(pmodecuid)=pin THEN titlestr$(pcwin)=LEFT$(wintitle$(pcwin),4)+" CU IN" ELSE titlestr$(pcwin)=LEFT$(wintitle$(pcwin),4)+" CU OUT"
1500 IF pmode%(pmodeclid)=pin THEN titlestr$(pcwin)=titlestr$(pcwin)+" CL IN" ELSE titlestr$(pcwin)=titlestr$(pcwin)+" CL OUT" 
1510 REM Print the titles
1520 FOR id=pawin TO pcwin
1530 LOCATE windata%(id,lpoint)+1, windata%(id,tpoint)-2:PRINT titlestr$(id)
1540 NEXT id
1550 RETURN
1560 '
1570 REM ****************************************************
1580 REM Initialise PIO
1590 REM ****************************************************
1600 OUT paddr%(ctrlid),ctrl
1610 PRINT #logwin, "OUT ";HEX$(paddr%(ctrlid),4);","HEX$(ctrl,2)
1620 RETURN
1630 '
1640 REM ****************************************************
1650 REM Read Command Line
1660 REM ****************************************************
1670 LINE INPUT #cmdwin,;"P=XX";command$
1680 outport$=LEFT$(command$,1):outvalue$=MID$(command$,3,2)
1690 IF outport$="A" THEN pdata%(paid)=VAL("&"+outvalue$)
1700 IF outport$="B" THEN pdata%(pbid)=VAL("&"+outvalue$)
1710 IF outport$="C" THEN pdata%(pcid)=VAL("&"+outvalue$)
1720 CLS #cmdwin
1730 RETURN
1740 '
1750 REM ****************************************************
1760 REM *** Write to ports
1770 REM ****************************************************
1780 FOR id=pmodeaid TO pmodebid
1790 IF pmode%(id)=pout THEN OUT paddr%(id), pdata%(id):PRINT #logwin, "OUT ";HEX$(paddr%(id),4);",";HEX$(pdata%(id),2)
1800 NEXT id
1810 IF pmode%(pmodecuid)=pout OR pmode%(pmodeclid)=pout THEN OUT paddr%(pcid), pdata%(pcid):PRINT #logwin, "OUT ";HEX$(paddr%(pcid),4);",";HEX$(pdata%(pcid),2)
1820 RETURN
1830 '
1840 REM ****************************************************
1850 REM *** Read from ports
1860 REM ****************************************************
1870 FOR id=pmodeaid TO pmodebid
1880 IF pmode%(id)=pin THEN pdata%(id)=INP(paddr%(id)):PRINT #logwin, "IN ";HEX$(paddr%(id),4);",";HEX$(pdata%(id),2)
1890 NEXT id
1900 pcdata%=0 'temp to hold read from port C'
1910 IF pmode%(pmodecuid)=pin OR pmode%(pmodeclid)=pin THEN pcdata%=INP(paddr%(pcid)):PRINT #logwin, "IN ";HEX$(paddr%(pcid),4);",";HEX$(pcdata%,2)
1920 '
1930 REM read in the upper or lower of port C
1940 IF pmode%(pmodecuid)=pin THEN pdatacu$=LEFT$(HEX$(pcdata%,2),1) ELSE pdatacu$=LEFT$(HEX$(pdata%(pcid)),1)
1950 IF pmode%(pmodeclid)=pin THEN pdatacl$=RIGHT$(HEX$(pcdata%,2),1) ELSE pdatacl$=RIGHT$(HEX$(pdata%(pcid)),1)
1960 '
1970 REM join the upper and lower back together
1980 IF pmode%(pmodecuid)=pin OR pmode%(pmodeclid)=pin THEN pdata%(pcid)=VAL("&"+pdatacu$+pdatacl$)
1990 RETURN
2000 