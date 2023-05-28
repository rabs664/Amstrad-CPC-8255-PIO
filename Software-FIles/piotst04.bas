10 MODE 2
20 GOSUB 220:'Setup globals
30 GOSUB 880:'Setup functions
40 GOSUB 1100:'Draw windows
50 GOSUB 1320:'Print Address
60 GOSUB 1260:'Print Control Word
70 GOSUB 1180:'Print Port Values
80 GOSUB 1360:'Print Port In or Out Modes
90 GOSUB 1550:'Initialise PIO
100 GOSUB 1620:'Read command line
110 GOSUB 1730:'Write to ports
120 GOSUB 1820:'Read from ports
130 GOSUB 1180:'Print Port Values
140 GOTO 100
150 END
160 '
170 REM ****************************************************
180 REM Setup globals
190 REM ****************************************************
200 '
210 REM Port IDs
220 paid=1:pbid=2:pcid=3:ctrlid=4:'Port Ids
230 '
240 REM Windows Ids
250 pawin=1:pbwin=2:pcwin=3:ctrlwin=4:addrwin=5:cmdwin=6:logwin=7:'Window Ids, match port Ids
260 '
270 REM pio base address
280 pioaddr=&F8E0
290 '
300 REM port and ctrl address
310 DIM paddr%(4):'1=pa, 2=pb, 3=pc, ctrl=4
320 FOR id=1 TO 4
330 paddr%(id)=pioaddr+(id-1)
340 NEXT id
350 '
360 REM the ctrl value
370 ctrl=&82
380 '
390 REM Mode bits positions within ctrl
400 pmodeaid=1:pmodebid=2:pmodecuid=3:pmodeclid=4
410 DIM pmodebit%(4):'pa=1, pb=2, pcu=3, pcl=4, 0 is not used
420 FOR id=1 TO 4
430 READ pmodebit%(id)
440 NEXT id
450 '
460 DATA &X00010000,&X00000010,&X00001000,&X00000001
470 '
480 pout=0:pin=1:'output and input modes
490 '
500 REM Window data
510 maxwin=7:'8 windows, 0 is the main window
520 lpoint=0:rpoint=1:tpoint=2:bpoint=3:'Window points left=0, right=1, top=2, bottom=3
530 DIM windata%(maxwin,3):'window dimensions windim(id,left|right|top|bottom), id 0 is main window
540 FOR id=1 TO maxwin
550 FOR point=lpoint TO bpoint:'left=0,right=1,top=2,bottom=3
560 READ windata%(id,point)
570 NEXT point
580 NEXT id
590 '
600 DATA 2,24,9,9:'window 1 Port A
610 DATA 28,52,9,9:'window 2 Port B 
620 DATA 56,79,9,9:'window 3 Port C
630 DATA 41,79,4,4:'window 4 Control
640 DATA 2,37,4,4:'window 5 Address
650 DATA 2,79,14,14:'window 6 command
660 DATA 2,79,19,24:'window 7 log
670 '
680 REM Window titles
690 DIM wintitle$(maxwin):'window title wintitle$(id), id 0 is main window
700 FOR id=1 TO maxwin
710 READ wintitle$(id)
720 NEXT id
730 DATA "PORT A","PORT B","PORT C","CONTROL","ADDRESS","COMMAND","LOG"
740 '
750 REM Current port data
760 DIM pdata%(3):'only 1 to 3 is used, 0 is not used
770 '
780 REM Defined Input or Output Mode for Ports in Control word
790 DIM pmode%(4):'1=pa,2=pb,3=pcu,4=pcl
800 FOR id=pmodeaid TO pmodeclid
810 IF(ctrl AND pmodebit%(id))=pmodebit%(id) THEN pmode%(id)=pin ELSE pmode%(id)=pout
820 NEXT id
830 RETURN
840 '
850 REM ****************************************************
860 REM *** Setup Functions for calculating window borders
870 REM ****************************************************
880 DEF FNx1=(640-(640-(left-1)*8))-8
890 DEF FNy1=(400-((bottom+1)*16))
900 DEF FNx2=(640-(640-(left-1)*8))-8
910 DEF FNy2=(400-((top-2)*16))+8
920 DEF FNx3=((right+1)*8)-1
930 DEF FNy3=(400-((top-2)*16)+8)
940 DEF FNx4=((right+1)*8)-1
950 DEF FNy4=(400-((bottom+1)*16))
960 RETURN
970 '
980 REM ****************************************************
990 REM *** Draw a window (title,left,right,top,bottom)
1000 REM ****************************************************
1010 WINDOW #id,left,right,top,bottom
1020 MOVE FNx1,FNy1:DRAW FNx2,FNy2:DRAW FNx3,FNy3:DRAW FNx4,FNy4:DRAW FNx1,FNy1
1030 LOCATE left+1,top-2
1040 PRINT title$
1050 RETURN
1060 '
1070 REM ****************************************************
1080 REM *** Create Windows
1090 REM ****************************************************
1100 FOR id=pawin TO maxwin
1110 left=windata%(id,lpoint):right=windata%(id,rpoint):top=windata%(id,tpoint):bottom=windata%(id,bpoint):title$=wintitle$(id):GOSUB 1010:'draw window
1120 NEXT id
1130 RETURN
1140 '
1150 REM ****************************************************
1160 REM Print Port Data        
1170 REM ****************************************************
1180 FOR id=paid TO pcid
1190 PRINT #id,HEX$(pdata%(id),2)
1200 NEXT id
1210 RETURN
1220 '
1230 REM ****************************************************
1240 REM Print the Control Word
1250 REM ****************************************************
1260 PRINT #ctrlwin,HEX$(ctrl,2)
1270 RETURN
1280 '
1290 REM ****************************************************
1300 REM Print Address
1310 REM ****************************************************
1320 PRINT #addrwin,HEX$(pioaddr,2)
1330 RETURN
1340 '
1350 REM ****************************************************
1360 REM Print Input or Output Modes for Ports
1370 REM ****************************************************
1380 DIM titlestr$(3):'temp title string
1390 REM Ports A and B
1400 FOR id=pawin TO pbwin
1410 IF pmode%(id)=pin THEN titlestr$(id)=wintitle$(id)+" IN" ELSE titlestr$(id)=wintitle$(id)+" OUT"
1420 NEXT id
1430 REM Port C is split into upper and lower
1440 IF pmode%(pmodecuid)=pin THEN titlestr$(pcwin)=LEFT$(wintitle$(pcwin),4)+" CU IN" ELSE titlestr$(pcwin)=LEFT$(wintitle$(pcwin),4)+" CU OUT"
1450 IF pmode%(pmodeclid)=pin THEN titlestr$(pcwin)=titlestr$(pcwin)+" CL IN" ELSE titlestr$(pcwin)=titlestr$(pcwin)+" CL OUT" 
1460 REM Print the titles
1470 FOR id=pawin TO pcwin
1480 LOCATE windata%(id,lpoint)+1, windata%(id,tpoint)-2:PRINT titlestr$(id)
1490 NEXT id
1500 RETURN
1510 '
1520 REM ****************************************************
1530 REM Initialise PIO
1540 REM ****************************************************
1550 OUT paddr%(ctrlid),ctrl
1560 PRINT #logwin, "OUT ";HEX$(paddr%(ctrlid),4);","HEX$(ctrl,2)
1570 RETURN
1580 '
1590 REM ****************************************************
1600 REM Read Command Line
1610 REM ****************************************************
1620 LINE INPUT #cmdwin,;"P=XX";command$
1630 outport$=LEFT$(command$,1):outvalue$=MID$(command$,3,2)
1640 IF outport$="A" THEN pdata%(paid)=VAL("&"+outvalue$)
1650 IF outport$="B" THEN pdata%(pbid)=VAL("&"+outvalue$)
1660 IF outport$="C" THEN pdata%(pcid)=VAL("&"+outvalue$)
1670 CLS #cmdwin
1680 RETURN
1690 '
1700 REM ****************************************************
1710 REM *** Write to ports
1720 REM ****************************************************
1730 FOR id=pmodeaid TO pmodebid
1740 IF pmode%(id)=pout THEN OUT paddr%(id), pdata%(id):PRINT #logwin, "OUT ";HEX$(paddr%(id),4);",";HEX$(pdata%(id),2)
1750 NEXT id
1760 IF pmode%(pmodecuid)=pout OR pmode%(pmodeclid)=pout THEN OUT paddr%(pcid), pdata%(pcid):PRINT #logwin, "OUT ";HEX$(paddr%(pcid),4);",";HEX$(pdata%(pcid),2)
1770 RETURN
1780 '
1790 REM ****************************************************
1800 REM *** Read from ports
1810 REM ****************************************************
1820 FOR id=pmodeaid TO pmodebid
1830 IF pmode%(id)=pin THEN pdata%(id)=INP(paddr%(id)):PRINT #logwin, "IN ";HEX$(paddr%(id),4);",";HEX$(pdata%(id),2)
1840 NEXT id
1850 pcdata%=0 'temp to hold read from port C'
1860 IF pmode%(pmodecuid)=pin OR pmode%(pmodeclid)=pin THEN pcdata%=INP(paddr%(pcid)):PRINT #logwin, "IN ";HEX$(paddr%(pcid),4);",";HEX$(pcdata%,2)
1870 '
1880 REM read in the upper or lower of port C
1890 IF pmode%(pmodecuid)=pin THEN pdatacu$=LEFT$(HEX$(pcdata%,2),1) ELSE pdatacu$=LEFT$(HEX$(pdata%(pcid)),1)
1900 IF pmode%(pmodeclid)=pin THEN pdatacl$=RIGHT$(HEX$(pcdata%,2),1) ELSE pdatacl$=RIGHT$(HEX$(pdata%(pcid)),1)
1910 '
1920 REM join the upper and lower back together
1930 IF pmode%(pmodecuid)=pin OR pmode%(pmodeclid)=pin THEN pdata%(pcid)=VAL("&"+pdatacu$+pdatacl$)
1940 RETURN
