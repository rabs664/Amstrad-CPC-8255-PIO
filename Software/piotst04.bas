10 REM ****************************************************
20 REM Basic Test Program 04
30 REM 
40 REM Enter Port A,B or C then = and value in hex to write to a port (i.e. A=01) and press enter
50 REM Program will write to ports defined as out and read from ports defined as in and display the current values
60 REM
70 REM Base Address of 8255 is defined by pioaddr
80 REM Ctrl Byte is defined by ctrl
85 REM 
86 REM Version 1.0 15/06/23 First Version
90 REM *****************************************************
100 MODE 2
110 GOSUB 310:'Setup globals
120 GOSUB 970:'Setup functions
130 GOSUB 1190:'Draw windows
140 GOSUB 1410:'Print Address
150 GOSUB 1350:'Print Control Word
160 GOSUB 1270:'Print Port Values
170 GOSUB 1450:'Print Port In or Out Modes
180 GOSUB 1640:'Initialise PIO
190 GOSUB 1710:'Read command line
200 GOSUB 1820:'Write to ports
210 GOSUB 1910:'Read from ports
220 GOSUB 1270:'Print Port Values
230 GOTO 190
240 END
250 '
260 REM ****************************************************
270 REM Setup globals
280 REM ****************************************************
290 '
300 REM Port IDs
310 paid=1:pbid=2:pcid=3:ctrlid=4:'Port Ids
320 '
330 REM Windows Ids
340 pawin=1:pbwin=2:pcwin=3:ctrlwin=4:addrwin=5:cmdwin=6:logwin=7:'Window Ids, match port Ids
350 '
360 REM pio base address
370 pioaddr=&F8E0
380 '
390 REM port and ctrl address
400 DIM paddr%(4):'1=pa, 2=pb, 3=pc, ctrl=4
410 FOR id=1 TO 4
420 paddr%(id)=pioaddr+(id-1)
430 NEXT id
440 '
450 REM the ctrl value
460 ctrl=&82
470 '
480 REM Mode bits positions within ctrl
490 pmodeaid=1:pmodebid=2:pmodecuid=3:pmodeclid=4
500 DIM pmodebit%(4):'pa=1, pb=2, pcu=3, pcl=4, 0 is not used
510 FOR id=1 TO 4
520 READ pmodebit%(id)
530 NEXT id
540 '
550 DATA &X00010000,&X00000010,&X00001000,&X00000001
560 '
570 pout=0:pin=1:'output and input modes
580 '
590 REM Window data
600 maxwin=7:'8 windows, 0 is the main window
610 lpoint=0:rpoint=1:tpoint=2:bpoint=3:'Window points left=0, right=1, top=2, bottom=3
620 DIM windata%(maxwin,3):'window dimensions windim(id,left|right|top|bottom), id 0 is main window
630 FOR id=1 TO maxwin
640 FOR point=lpoint TO bpoint:'left=0,right=1,top=2,bottom=3
650 READ windata%(id,point)
660 NEXT point
670 NEXT id
680 '
690 DATA 2,24,9,9:'window 1 Port A
700 DATA 28,52,9,9:'window 2 Port B 
710 DATA 56,79,9,9:'window 3 Port C
720 DATA 41,79,4,4:'window 4 Control
730 DATA 2,37,4,4:'window 5 Address
740 DATA 2,79,14,14:'window 6 command
750 DATA 2,79,19,24:'window 7 log
760 '
770 REM Window titles
780 DIM wintitle$(maxwin):'window title wintitle$(id), id 0 is main window
790 FOR id=1 TO maxwin
800 READ wintitle$(id)
810 NEXT id
820 DATA "PORT A","PORT B","PORT C","CONTROL","ADDRESS","COMMAND","LOG"
830 '
840 REM Current port data
850 DIM pdata%(3):'only 1 to 3 is used, 0 is not used
860 '
870 REM Defined Input or Output Mode for Ports in Control word
880 DIM pmode%(4):'1=pa,2=pb,3=pcu,4=pcl
890 FOR id=pmodeaid TO pmodeclid
900 IF(ctrl AND pmodebit%(id))=pmodebit%(id) THEN pmode%(id)=pin ELSE pmode%(id)=pout
910 NEXT id
920 RETURN
930 '
940 REM ****************************************************
950 REM *** Setup Functions for calculating window borders
960 REM ****************************************************
970 DEF FNx1=(640-(640-(left-1)*8))-8
980 DEF FNy1=(400-((bottom+1)*16))
990 DEF FNx2=(640-(640-(left-1)*8))-8
1000 DEF FNy2=(400-((top-2)*16))+8
1010 DEF FNx3=((right+1)*8)-1
1020 DEF FNy3=(400-((top-2)*16)+8)
1030 DEF FNx4=((right+1)*8)-1
1040 DEF FNy4=(400-((bottom+1)*16))
1050 RETURN
1060 '
1070 REM ****************************************************
1080 REM *** Draw a window (title,left,right,top,bottom)
1090 REM ****************************************************
1100 WINDOW #id,left,right,top,bottom
1110 MOVE FNx1,FNy1:DRAW FNx2,FNy2:DRAW FNx3,FNy3:DRAW FNx4,FNy4:DRAW FNx1,FNy1
1120 LOCATE left+1,top-2
1130 PRINT title$
1140 RETURN
1150 '
1160 REM ****************************************************
1170 REM *** Create Windows
1180 REM ****************************************************
1190 FOR id=pawin TO maxwin
1200 left=windata%(id,lpoint):right=windata%(id,rpoint):top=windata%(id,tpoint):bottom=windata%(id,bpoint):title$=wintitle$(id):GOSUB 1100:'draw window
1210 NEXT id
1220 RETURN
1230 '
1240 REM ****************************************************
1250 REM Print Port Data        
1260 REM ****************************************************
1270 FOR id=paid TO pcid
1280 PRINT #id,HEX$(pdata%(id),2)
1290 NEXT id
1300 RETURN
1310 '
1320 REM ****************************************************
1330 REM Print the Control Word
1340 REM ****************************************************
1350 PRINT #ctrlwin,HEX$(ctrl,2)
1360 RETURN
1370 '
1380 REM ****************************************************
1390 REM Print Address
1400 REM ****************************************************
1410 PRINT #addrwin,HEX$(pioaddr,2)
1420 RETURN
1430 '
1440 REM ****************************************************
1450 REM Print Input or Output Modes for Ports
1460 REM ****************************************************
1470 DIM titlestr$(3):'temp title string
1480 REM Ports A and B
1490 FOR id=pawin TO pbwin
1500 IF pmode%(id)=pin THEN titlestr$(id)=wintitle$(id)+" IN" ELSE titlestr$(id)=wintitle$(id)+" OUT"
1510 NEXT id
1520 REM Port C is split into upper and lower
1530 IF pmode%(pmodecuid)=pin THEN titlestr$(pcwin)=LEFT$(wintitle$(pcwin),4)+" CU IN" ELSE titlestr$(pcwin)=LEFT$(wintitle$(pcwin),4)+" CU OUT"
1540 IF pmode%(pmodeclid)=pin THEN titlestr$(pcwin)=titlestr$(pcwin)+" CL IN" ELSE titlestr$(pcwin)=titlestr$(pcwin)+" CL OUT" 
1550 REM Print the titles
1560 FOR id=pawin TO pcwin
1570 LOCATE windata%(id,lpoint)+1, windata%(id,tpoint)-2:PRINT titlestr$(id)
1580 NEXT id
1590 RETURN
1600 '
1610 REM ****************************************************
1620 REM Initialise PIO
1630 REM ****************************************************
1640 OUT paddr%(ctrlid),ctrl
1650 PRINT #logwin, "OUT ";HEX$(paddr%(ctrlid),4);","HEX$(ctrl,2)
1660 RETURN
1670 '
1680 REM ****************************************************
1690 REM Read Command Line
1700 REM ****************************************************
1710 LINE INPUT #cmdwin,;"P=XX";command$
1720 outport$=LEFT$(command$,1):outvalue$=MID$(command$,3,2)
1730 IF outport$="A" THEN pdata%(paid)=VAL("&"+outvalue$)
1740 IF outport$="B" THEN pdata%(pbid)=VAL("&"+outvalue$)
1750 IF outport$="C" THEN pdata%(pcid)=VAL("&"+outvalue$)
1760 CLS #cmdwin
1770 RETURN
1780 '
1790 REM ****************************************************
1800 REM *** Write to ports
1810 REM ****************************************************
1820 FOR id=pmodeaid TO pmodebid
1830 IF pmode%(id)=pout THEN OUT paddr%(id), pdata%(id):PRINT #logwin, "OUT ";HEX$(paddr%(id),4);",";HEX$(pdata%(id),2)
1840 NEXT id
1850 IF pmode%(pmodecuid)=pout OR pmode%(pmodeclid)=pout THEN OUT paddr%(pcid), pdata%(pcid):PRINT #logwin, "OUT ";HEX$(paddr%(pcid),4);",";HEX$(pdata%(pcid),2)
1860 RETURN
1870 '
1880 REM ****************************************************
1890 REM *** Read from ports
1900 REM ****************************************************
1910 FOR id=pmodeaid TO pmodebid
1920 IF pmode%(id)=pin THEN pdata%(id)=INP(paddr%(id)):PRINT #logwin, "IN ";HEX$(paddr%(id),4);",";HEX$(pdata%(id),2)
1930 NEXT id
1940 pcdata%=0 'temp to hold read from port C'
1950 IF pmode%(pmodecuid)=pin OR pmode%(pmodeclid)=pin THEN pcdata%=INP(paddr%(pcid)):PRINT #logwin, "IN ";HEX$(paddr%(pcid),4);",";HEX$(pcdata%,2)
1960 '
1970 REM read in the upper or lower of port C
1980 IF pmode%(pmodecuid)=pin THEN pdatacu$=LEFT$(HEX$(pcdata%,2),1) ELSE pdatacu$=LEFT$(HEX$(pdata%(pcid)),1)
1990 IF pmode%(pmodeclid)=pin THEN pdatacl$=RIGHT$(HEX$(pcdata%,2),1) ELSE pdatacl$=RIGHT$(HEX$(pdata%(pcid)),1)
2000 '
2010 REM join the upper and lower back together
2020 IF pmode%(pmodecuid)=pin OR pmode%(pmodeclid)=pin THEN pdata%(pcid)=VAL("&"+pdatacu$+pdatacl$)
2030 RETURN
2040 