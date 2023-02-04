//KSGMPGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//*
//* NOTE - Recompile of the GCCMVS 'HELP' screeen at the bottom of
//*        this job should be commented (add a '//' in front of it)
//*        if you do not have GCCMVS installed on your machine...
//*
//*
//KSGMPGM EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. KSGMPGM.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * * Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      *///////////////////////////////////////////////////////////////
      * KSGMPGM (tranid KSGM) is the 'good morning message' program,
      * If KSGM is the startup PLT transaction (the default) then this
      * program's screen is the first you see when you start KICKS.

      *///////////////////////////////////////////////////////////////
      * Changes for 1.1.0
      *   'COPY' syntax changed for new cobol pre processor
      *   Use of ASKTIME/FORMATTIME instead of EIB or COBOL verbs
      *   Use of alternate screen sizes when available

      *///////////////////////////////////////////////////////////////
      * Changes for 1.1.3
      *   Dynamic refresh using RECEIVE CHECK
      *   RETURN TRANSID to EIBTRNID instead of 'KSGM'

      *///////////////////////////////////////////////////////////////
      * Changes for 1.4.0
      *   PF1 to help screen
      *   Maps for more term types
      *   Ignore initial PA2 (TSO only)

      *///////////////////////////////////////////////////////////////
      * Changes for 1.4.2
      *   Improved map selection
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'KSGMPGM  WORKING STORAGE'.
       77  RC                  PIC S9(4)  COMP.
       77  WS-ABSTIME          PIC S9(15) COMP-3.
       77  WS-TWALENG          PIC S9(4)  COMP.
       77  WS-DELAYTIME        PIC S9(4)  COMP.
       77  WS-DEFSCRNHT        PIC S9(4)  COMP VALUE +0.
       77  WS-DEFSCRNWD        PIC S9(4)  COMP VALUE +0.
       77  WS-ALTSCRNHT        PIC S9(4)  COMP VALUE +0.
       77  WS-ALTSCRNWD        PIC S9(4)  COMP VALUE +0.
       77  WS-WHICHMAP         PIC S9(4)  COMP VALUE +0.

       01  WS-MAPX01.
           05  WS-KSGM         PIC X(4)  VALUE 'KSGM'.
<CMS>
           05  FILLER          PIC X(13) VALUE ' for cms user'.
</CMS>
<TSO>
           05  FILLER          PIC X(13) VALUE ' for tso user'.
</TSO>

       01  WS-MAPX02.
<CMS>
           05  FILLER          PIC X(18) VALUE 'For CMS'.
</CMS>
<TSO>
           05  FILLER          PIC X(18) VALUE 'For TSO'.
</TSO>

      * vars for shuffle-colors
       01  I                   PIC S9(8) COMP.
       01  J                   PIC S9(8) COMP.
       01  K                   PIC S9(8) COMP.
       01  FILLER REDEFINES K.
           05  FILLER          PIC X(3).
           05  KX              PIC X.

      * vars for random-number
       01  IA                  PIC S9(8) COMP VALUE +13077.
       01  IM                  PIC S9(8) COMP VALUE +32768.
       01  IC                  PIC S9(8) COMP VALUE +6925.
       01  FSEED               COMP-1.
       01  FIM                 COMP-1.
       01  IRNDM               PIC S9(8) COMP.

      * working storage copy of comm-area
       01  WS-COMM.
           05  ISEED           PIC S9(8) COMP.
           05  COLORS OCCURS 5 PIC X.
           05  HILITE OCCURS 5 PIC X.

       COPY KSGMAP.

       COPY KIKAID.
       COPY KIKBMSCA.

       LINKAGE SECTION.
       01  KIKCOMMAREA PIC X(14).

       PROCEDURE DIVISION.

           IF EIBAID = KIKPF1
                EXEC KICKS XCTL PROGRAM('KSGMHLP') END-EXEC
           ELSE
           IF EIBCALEN = 0
                MOVE KIKDFT TO COLORS (1), COLORS (2), COLORS (3),
                               COLORS (4), COLORS (5)
                MOVE KIKDFT TO HILITE (1), HILITE (2), HILITE (3),
                               HILITE (4), HILITE (5)
                MOVE EIBTIME TO ISEED
           ELSE
           IF EIBCALEN NOT = 14
                EXEC KICKS ABEND ABCODE('COMM') END-EXEC
           ELSE
                MOVE KIKCOMMAREA TO WS-COMM
                EXEC KICKS
                  RECEIVE MAP('KSGMAPP') MAPSET('KSGMAP') RESP(RC)
                END-EXEC
                IF EIBAID = KIKCLEAR OR KIKPF3
                   PERFORM ADJUST-SCREENSIZE
                   IF WS-WHICHMAP = 0
                       EXEC KICKS SEND CONTROL ERASE FREEKB END-EXEC
                       EXEC KICKS RETURN END-EXEC
                   ELSE
                       EXEC KICKS SEND CONTROL ERASE ALTERNATE FREEKB
                       END-EXEC
                       EXEC KICKS RETURN END-EXEC.
       REDO-IT.
<TSO>
      * ignore initial PA2 in TSO...
           IF EIBAID = KIKPA2
              IF EIBTASKN < 3
                 GO TO CHEK-IT.
</TSO>
           PERFORM FILL-IN-MAP.
           IF WS-WHICHMAP = 1
               EXEC KICKS
                 SEND MAP('KSGMAPQ') MAPSET('KSGMAP') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 2
               EXEC KICKS
                 SEND MAP('KSGMAPR') MAPSET('KSGMAP') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 3
               EXEC KICKS
                 SEND MAP('KSGMAPS') MAPSET('KSGMAP') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 4
               EXEC KICKS
                 SEND MAP('KSGMAPT') MAPSET('KSGMAP') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 5
               EXEC KICKS
                 SEND MAP('KSGMAPU') MAPSET('KSGMAP') ERASE ALTERNATE
               END-EXEC
           ELSE
               EXEC KICKS
                 SEND MAP('KSGMAPP') MAPSET('KSGMAP') ERASE
               END-EXEC.

       CHEK-IT.

           EXEC KICKS ASSIGN TWALENG(WS-TWALENG) END-EXEC.
           IF WS-TWALENG < 3  GO TO STOP-IT.
           IF WS-TWALENG > 60 GO TO STOP-IT.
           COMPUTE WS-DELAYTIME = 10 * WS-TWALENG.
           PERFORM DELAY-IT
               VARYING I FROM +1 BY +1 UNTIL I > WS-DELAYTIME.
           GO TO REDO-IT.

       STOP-IT.

           EXEC KICKS
             RETURN TRANSID(EIBTRNID) COMMAREA(WS-COMM)
           END-EXEC.

       DELAY-IT.
      *   'RECEIVE CHECK' INCLUDES 1/10 SECOND DELAY...
           EXEC KICKS RECEIVE CHECK END-EXEC.
           IF EIBAID EQUAL 'R' GO TO STOP-IT.

       FILL-IN-MAP SECTION.
           PERFORM ADJUST-SCREENSIZE.
           MOVE LOW-VALUES TO KSGMAPPO.
      *    FILL IN THE TRAN ID
           MOVE EIBTRNID  TO WS-KSGM.
           MOVE WS-MAPX01 TO MAPX01O.
      *    FILL IN THE USER ID
           EXEC KICKS ASSIGN USERID(MAPA01O) END-EXEC.
      *    FILL IN THE TERMINAL ID
           MOVE EIBTRMID TO MAPB01O.
      *    FILL IN THE SYSTEM ID
           MOVE EIBSYSID TO MAPE01O.
      *    FILL IN THE TIME AND DATE USING ASKTIME/FORMATTIME
           EXEC KICKS ASKTIME ABSTIME(WS-ABSTIME) END-EXEC.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             TIME(MAPC01O) TIMESEP(':')
           END-EXEC.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             MMDDYY(MAPD01O) DATESEP('/')
           END-EXEC.
      *    COLOR THE BIG LETTERS
           PERFORM SHUFFLE-COLORS.
           PERFORM COLOR-LETTERS.
           MOVE WS-MAPX02 TO MAPA20O.
       FILL-IN-MAP-EXIT.
           EXIT.

       SHUFFLE-COLORS SECTION.
           EXEC KICKS ASSIGN TWALENG(WS-TWALENG) END-EXEC.
           IF WS-TWALENG = 1
              MOVE KIKTURQ  TO COLORS(1)
              MOVE KIKGREEN TO COLORS(2)
              MOVE KIKRED   TO COLORS(3)
              MOVE KIKBLUE  TO COLORS(4)
              MOVE KIKNEUTR TO COLORS(5)
              GO TO SHUFFLE-COLORS-EXIT.
           MOVE +1 TO I.
       SC-1.
           IF I > 5 GO TO SHUFFLE-COLORS-EXIT.
           PERFORM RANDOM-NUMBER.
           DIVIDE IRNDM BY 7 GIVING J REMAINDER K.
           ADD +241 TO K.
      *    don't want 2nd K to be red...
           IF (I = +5) AND (KX = KIKRED) GO TO SC-1.
           MOVE +1 TO J.
       SC-2.
      *    don't want more than one of any color or
      *          any color the same as last time
           IF COLORS (J) = KX GO TO SC-1.
           ADD +1 TO J.
           IF J NOT > I GO TO SC-2.
           MOVE KX TO COLORS (I).
           ADD +1 TO I.
           GO TO SC-1.
       SHUFFLE-COLORS-EXIT.
           EXIT.

       RANDOM-NUMBER SECTION.
      *    simple LCG algorithm (lifted from Boillot fortran book)
           MULTIPLY ISEED BY IA  GIVING ISEED.
           IF ISEED < 0 COMPUTE ISEED = -1 * ISEED.
           ADD IC, ISEED         GIVING ISEED.
           DIVIDE ISEED BY IM    GIVING IRNDM  REMAINDER ISEED.
           MOVE ISEED TO FSEED.
           MOVE IM    TO FIM.
           DIVIDE FSEED BY FIM   GIVING FIM.
           COMPUTE FSEED = 1000.0 * FIM.
           MOVE FSEED TO IRNDM.
       RANDOM-NUMBER-EXIT.
           EXIT.

       COLOR-LETTERS SECTION.
      *    1ST 'K' OF KICKS IS HILITE, COLOR(1)
           MOVE HILITE (1) TO MAPA06H, MAPA07H, MAPA08H, MAPA09H,
                              MAPA10H, MAPA11H, MAPA12H, MAPA13H,
                              MAPA14H, MAPA15H, MAPA16H, MAPA17H.
           MOVE COLORS (1) TO MAPA06C, MAPA07C, MAPA08C, MAPA09C,
                              MAPA10C, MAPA11C, MAPA12C, MAPA13C,
                              MAPA14C, MAPA15C, MAPA16C, MAPA17C.
      *   'I' OF KICKS IS HILITE, COLOR(2)
           MOVE HILITE (2) TO MAPB06H, MAPB07H, MAPB08H, MAPB09H,
                              MAPB10H, MAPB11H, MAPB12H, MAPB13H,
                              MAPB14H, MAPB15H, MAPB16H, MAPB17H.
           MOVE COLORS (2) TO MAPB06C, MAPB07C, MAPB08C, MAPB09C,
                              MAPB10C, MAPB11C, MAPB12C, MAPB13C,
                              MAPB14C, MAPB15C, MAPB16C, MAPB17C.
      *    'C' OF KICKS IS HILITE, COLOR(3)
           MOVE HILITE (3) TO MAPC06H, MAPC07H, MAPC08H, MAPC09H,
                              MAPC10H, MAPC11H, MAPC12H, MAPC13H,
                              MAPC14H, MAPC15H, MAPC16H, MAPC17H.
           MOVE COLORS (3) TO MAPC06C, MAPC07C, MAPC08C, MAPC09C,
                              MAPC10C, MAPC11C, MAPC12C, MAPC13C,
                              MAPC14C, MAPC15C, MAPC16C, MAPC17C.
      *    2ND 'K' OF KICKS IS HILITE, COLOR(4)
           MOVE HILITE (4) TO MAPD06H, MAPD07H, MAPD08H, MAPD09H,
                              MAPD10H, MAPD11H, MAPD12H, MAPD13H,
                              MAPD14H, MAPD15H, MAPD16H, MAPD17H.
           MOVE COLORS (4) TO MAPD06C, MAPD07C, MAPD08C, MAPD09C,
                              MAPD10C, MAPD11C, MAPD12C, MAPD13C,
                              MAPD14C, MAPD15C, MAPD16C, MAPD17C.
      *    'S' OF KICKS IS HILITE, COLOR(5)
           MOVE HILITE (5) TO MAPE06H, MAPE07H, MAPE08H, MAPE09H,
                              MAPE10H, MAPE11H, MAPE12H, MAPE13H,
                              MAPE14H, MAPE15H, MAPE16H, MAPE17H.
           MOVE COLORS (5) TO MAPE06C, MAPE07C, MAPE08C, MAPE09C,
                              MAPE10C, MAPE11C, MAPE12C, MAPE13C,
                              MAPE14C, MAPE15C, MAPE16C, MAPE17C.
       COLOR-LETTERS-EXIT.
           EXIT.

       ADJUST-SCREENSIZE SECTION.
           EXEC KICKS ASSIGN DEFSCRNHT(WS-DEFSCRNHT) END-EXEC.
           EXEC KICKS ASSIGN DEFSCRNWD(WS-DEFSCRNWD) END-EXEC.
           EXEC KICKS ASSIGN ALTSCRNHT(WS-ALTSCRNHT) END-EXEC.
           EXEC KICKS ASSIGN ALTSCRNWD(WS-ALTSCRNWD) END-EXEC.
      * primary select by default, but ensure it's OK
           IF WS-DEFSCRNWD NOT = 80 OR WS-DEFSCRNHT NOT = 24 THEN
               EXEC KICKS ABEND ABCODE('BADS') END-EXEC.
      * select largest alternate that matches width (if any)
           IF WS-ALTSCRNWD = 80  AND WS-ALTSCRNHT NOT < 32 THEN
               MOVE +1 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 80  AND WS-ALTSCRNHT NOT < 43 THEN
               MOVE +2 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 87  AND WS-ALTSCRNHT NOT < 32 THEN
               MOVE +3 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 132 AND WS-ALTSCRNHT NOT < 27 THEN
               MOVE +4 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 160 AND WS-ALTSCRNHT NOT < 62 THEN
               MOVE +5 TO WS-WHICHMAP.
       ADJUST-SCREENSIZE-EXIT.
           EXIT.
/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY KSGMPGM
 NAME  KSGMPGM(R)
/*
//KSGMLIC EXEC  PROC=K2KCOBCL
//*
//* compile the COBOL license display
//*
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. KSGMLIC.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * * Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT LICENSE ASSIGN UT-S-LICENSE.

       DATA DIVISION.

       FILE SECTION.
       FD  LICENSE
           RECORDING MODE F
           BLOCK CONTAINS 0 RECORDS
           LABEL RECORDS STANDARD.
       01  LICENSE-RECORD              PIC X(80).

       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'KSGMLIC  WORKING STORAGE'.
       77  WS-DEFSCRNHT        PIC S9(4)  COMP VALUE +0.
       77  WS-DEFSCRNWD        PIC S9(4)  COMP VALUE +0.
       77  WS-ALTSCRNHT        PIC S9(4)  COMP VALUE +0.
       77  WS-ALTSCRNWD        PIC S9(4)  COMP VALUE +0.
       77  TOP-LINE            PIC S9(4)  COMP VALUE +0.
       77  BOTTOM-LINE         PIC S9(4)  COMP VALUE +0.
       77  LINES-TO-DO         PIC S9(4)  COMP VALUE +21.
       77  I                   PIC S9(4)  COMP VALUE +0.
       77  J                   PIC S9(4)  COMP VALUE +0.
       77  SYSOUT-TOKEN        PIC X(8)  VALUE SPACES.

       01  MSG1-L              PIC S9(8)  COMP VALUE +57.
       01  MSG1 PIC X(57) VALUE
          'TOO MANY LINES OF LICENSE FILE FOUND IN KSGMLIC, 200 MAX.'.

       01  LICENSE-LINE-PRINT  PIC S9(8)  COMP VALUE +0.
       01  LICENSE-LINE-COUNT  PIC S9(8)  COMP VALUE +0.
       01  LICENSE-TABLE.
           05  LICENSE-LINE OCCURS 200 PIC X(80).

       COPY KSGMAPL.

       01  MAP-ARRAY REDEFINES KSGMAPPI.
           05  FILLER          PIC X(12).
           05  MA-LINES OCCURS 40.
      *        7 - L(2), F/A(1), CPHV(4)
               10  FILLER      PIC X(7).
               10  MA-LINE     PIC X(78).

       COPY KIKAID.
       COPY KIKBMSCA.

       PROCEDURE DIVISION.

       GET-LICENSE-INTO-MEMORY.

      * An example of using a non-CICS api (ie, normal COBOL i/o)
      * in a KICKS program. In this case reading a sequential file
      * (a pds member actually) into a memory array

           OPEN INPUT LICENSE.

       READ-NEXT-LICENSE-LINE.

           READ LICENSE RECORD AT END GO TO DONE-WITH-FILE.
           IF LICENSE-LINE-COUNT < 200 THEN
               ADD +1 TO LICENSE-LINE-COUNT
               MOVE LICENSE-RECORD TO LICENSE-LINE (LICENSE-LINE-COUNT)
           ELSE
               CLOSE LICENSE
               EXEC KICKS SEND TEXT
                    FROM(MSG1)
                    ERASE NOHANDLE
               END-EXEC
               EXEC KICKS RECEIVE NOHANDLE END-EXEC
               EXEC KICKS RETURN END-EXEC.
           GO TO READ-NEXT-LICENSE-LINE.

       DONE-WITH-FILE.

           CLOSE LICENSE.

       OBTAIN-SCREEN-DIMENSIONS.

           EXEC KICKS ASSIGN DEFSCRNHT(WS-DEFSCRNHT) END-EXEC.
           EXEC KICKS ASSIGN DEFSCRNWD(WS-DEFSCRNWD) END-EXEC.
           EXEC KICKS ASSIGN ALTSCRNHT(WS-ALTSCRNHT) END-EXEC.
           EXEC KICKS ASSIGN ALTSCRNWD(WS-ALTSCRNWD) END-EXEC.
      * primary select by default, but ensure it's OK
           IF WS-DEFSCRNWD NOT = 80 OR WS-DEFSCRNHT NOT = 24 THEN
               EXEC KICKS ABEND ABCODE('BADS') END-EXEC.
      * select largest alternate that matches width (if any)
           IF WS-ALTSCRNWD = 80 AND WS-ALTSCRNHT NOT < 32 THEN
               MOVE 27 TO LINES-TO-DO.
           IF WS-ALTSCRNWD = 80 AND WS-ALTSCRNHT NOT < 43 THEN
               MOVE 40 TO LINES-TO-DO.

      * initialize for moving lines to screen

           MOVE 1 TO TOP-LINE.
           MOVE LICENSE-LINE-COUNT TO LICENSE-LINE-PRINT.
           IF LICENSE-LINE-COUNT NOT < LINES-TO-DO THEN
               GO TO SEND-SCREEN.

       PAD-TABLE.

           ADD +1 TO LICENSE-LINE-COUNT.
           MOVE SPACES TO LICENSE-LINE (LICENSE-LINE-COUNT).
           IF LICENSE-LINE-COUNT < LINES-TO-DO THEN
               GO TO PAD-TABLE.

       SEND-SCREEN.

           IF LINES-TO-DO = 40 THEN
               PERFORM SEND-43
           ELSE
           IF LINES-TO-DO = 27 THEN
               PERFORM SEND-30
           ELSE
               PERFORM SEND-24.

       GET-RESPONSE.

           EXEC KICKS RECEIVE NOHANDLE END-EXEC

           IF EIBAID = KIKPF3 OR EIBAID = KIKCLEAR THEN
               GO TO RETURN-TO-CALLER.

           IF EIBAID = KIKPF10 THEN GO TO PRINT-LICENSE.

           IF EIBAID = KIKPF7 THEN
               SUBTRACT LINES-TO-DO FROM TOP-LINE.

      * PF19 is shift PF7
           IF EIBAID = KIKPF19 THEN MOVE 1 TO TOP-LINE.

           IF EIBAID = KIKPF8 OR EIBAID = KIKENTER THEN
               ADD LINES-TO-DO TO TOP-LINE.

      * PF20 is shift PF8
           IF EIBAID = KIKPF20 THEN MOVE 999 TO TOP-LINE.

           IF TOP-LINE < 1 THEN MOVE 1 TO TOP-LINE.
           COMPUTE BOTTOM-LINE = TOP-LINE + LINES-TO-DO - 1.
           IF BOTTOM-LINE > LICENSE-LINE-COUNT THEN
               COMPUTE TOP-LINE =
                   LICENSE-LINE-COUNT - LINES-TO-DO + 1.
           IF TOP-LINE < 1 THEN MOVE 1 TO TOP-LINE.

           GO TO SEND-SCREEN.

       PRINT-LICENSE.

           EXEC KICKS SPOOLOPEN OUTPUT
                 TOKEN(SYSOUT-TOKEN) CLASS('A')
                 USERID('*') NODE('*')
                 NOHANDLE
           END-EXEC.

           PERFORM PRINT-LINES VARYING I FROM 1 BY 1
               UNTIL I > LICENSE-LINE-PRINT.

           EXEC KICKS SPOOLCLOSE
                 TOKEN(SYSOUT-TOKEN)
                 NOHANDLE
           END-EXEC.

           GO TO SEND-SCREEN.

       SEND-24.

           MOVE LOW-VALUES TO KSGMAPPO.
           MOVE TOP-LINE TO J.
           PERFORM MOVE-LINES VARYING I FROM 1 BY 1
               UNTIL I > LINES-TO-DO.
           EXEC KICKS SEND MAP('KSGMAPP')
               MAPSET('KSGMAPL')
               ERASE
               NOHANDLE
           END-EXEC.

       SEND-30.

           MOVE LOW-VALUES TO KSGMAPQO.
           MOVE TOP-LINE TO J.
           PERFORM MOVE-LINES VARYING I FROM 1 BY 1
               UNTIL I > LINES-TO-DO.
           EXEC KICKS SEND MAP('KSGMAPQ')
               MAPSET('KSGMAPL')
               ERASE ALTERNATE
               NOHANDLE
           END-EXEC.

       SEND-43.

           MOVE LOW-VALUES TO KSGMAPRO.
           MOVE TOP-LINE TO J.
           PERFORM MOVE-LINES VARYING I FROM 1 BY 1
               UNTIL I > LINES-TO-DO.
           EXEC KICKS SEND MAP('KSGMAPR')
               MAPSET('KSGMAPL')
               ERASE ALTERNATE
               NOHANDLE
           END-EXEC.

       MOVE-LINES.

           MOVE LICENSE-LINE (J) TO MA-LINE (I).
           ADD  1 TO J.

       PRINT-LINES.

           EXEC KICKS SPOOLWRITE
                 TOKEN(SYSOUT-TOKEN)
                 FROM(LICENSE-LINE (I))
                 NOHANDLE
           END-EXEC.

       RETURN-TO-CALLER.

           EXEC KICKS RETURN END-EXEC.

/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY KSGMLIC
 NAME  KSGMLIC(R)
/*
//* **** If you do not have GCCMVS installed on your machine you
//* should comment out the following job step by removing the '*'
//* from the following card, turning it into a '//' end of job...
//*
//*
//KSGMHLP EXEC  PROC=KIKGCCCL
//*
//* compile the GCCMVS help display
//*
//COPY.SYSUT1 DD *
 /////////////////////////////////////////////////////////////////////
 //   KICKS is an enhancement for TSO that lets you run your CICS
 //   applications directly in TSO instead of having to 'install'
 //   those apps in CICS.
 //   You don't even need CICS itself installed on your machine!
 //
 //   KICKS for TSO
 //   * Copyright 2008-2014, Michael Noel, All Rights Reserved.
 //
 //   Usage of 'KICKS for TSO' is in all cases subject to license.
 //   See http://www.kicksfortso.com
 //   for most current information regarding licensing options..
 ////////1/////////2/////////3/////////4/////////5/////////6/////////7

 /////////////////////////////////////////////////////////////////////
 //   5/2/2012 - near complete re-write for 14 bit sba support...
 //              ie, can't use strcat/strcpy anymore 'cause 14 bit
 //              sba's might contain 0's (or any other hex char).
 /////////////////////////////////////////////////////////////////////

<NT>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "kikaid.h"



 // >>>>>> table used to translate binary <<<<<<<<<<<
 // >>>>>> values into 3270 data stream values <<<<<<
 static char xlt3270[64] = {
 '\x40', '\xC1', '\xC2', '\xC3', '\xC4', '\xC5', '\xC6', '\xC7',
 '\xC8', '\xC9', '\x4A', '\x4B', '\x4C', '\x4D', '\x4E', '\x4F',
 '\x50', '\xD1', '\xD2', '\xD3', '\xD4', '\xD5', '\xD6', '\xD7',
 '\xD8', '\xD9', '\x5A', '\x5B', '\x5C', '\x5D', '\x5E', '\x5F',
 '\x60', '\x61', '\xE2', '\xE3', '\xE4', '\xE5', '\xE6', '\xE7',
 '\xE8', '\xE9', '\x6A', '\x6B', '\x6C', '\x6D', '\x6E', '\x6F',
 '\xF0', '\xF1', '\xF2', '\xF3', '\xF4', '\xF5', '\xF6', '\xF7',
 '\xF8', '\xF9', '\x7A', '\x7B', '\x7C', '\x7D', '\x7E', '\x7F'
 };


 // >>>>>> globals for screen geometry used to <<<<<<
 // >>>>>> convert sba's to/from row/columns.  <<<<<<
 static int sba_maxcol=80, sba_maxrow=24, sba_use14=0;

 // >>>>>> function to decode sba into row, col <<<<<<
 void decode_sba (unsigned char *sba, int *row, int *col) {
  int disp, fndc=-1, fndr=-1;

  // first translate into screen displacement
  *row = sba[0]; *col = sba[1];
  if((*row & 0x40) > 0) {
   // 12 bit, lookup code
   for (disp=0; disp<64; disp++) {
    if (*col == xlt3270[disp]) fndc = disp;
    if (*row == xlt3270[disp]) fndr = disp;
    }
   if((fndc < 0) || (fndr < 0)) { *row=-1; return; }
   disp = (64 * fndr) + fndc;
   }
  else {
   // 14 bit, simple displacement
   // -- even thou I won't send them, it's possbile
   // -- that the terminal will, so handle here...
   fndc = *col; fndr = *row;
   disp = (256 * fndr) + fndc;
   if (disp > (sba_maxcol*sba_maxrow))  { *row=-3; return; }
   }

  // then convert displacement to row/col
  *col = disp % sba_maxcol;
  *row = (disp - *col) / sba_maxcol;
  *row=*row+1; *col=*col+1;
  return;
  }


 // >>>>>> function to encode row, col into sba <<<<<<
 short encode_sba (int row, int col) {
  short disp;

  // first convert row, col to screen displacement
  disp  = row - 1;
  disp *= sba_maxcol;
  disp += col - 1;

  // 'wrap' displacement
  disp = disp % (sba_maxrow*sba_maxcol);

  // then translate displacement into 12/14 bit code
  if (sba_use14 > 0) {
   // make a 14 bit encoded sba
   if (disp != (disp & 0x3fff)) return -1;
   return disp;
   }
  else {
   // make a 12 bit encoded sba
   if (disp != (disp & 0x0fff)) return -2;
   row = disp % 64;   // low 6 bits
   col = disp / 64;   // hi  6 bits
   return(256*xlt3270[col]+ xlt3270[row]);
   }
  }


 // macros to simplify adding text and
 // commands to the 3270 output buffer

#define APPEND_MSG(txt)          \
{ int ltxt;                      \
 ltxt=strlen(txt);               \
 memcpy(&msg[msg_l], txt, ltxt); \
 msg_l += ltxt;                  \
}

#define PUT_SBA(r,c)                   \
{ short sbuf; int cmod;                \
 cmod=(altwd-80)/2;                    \
 if (cmod < 0) cmod = 0;               \
 cmod += c;                            \
 sbuf=encode_sba(r,cmod);              \
 memcpy(&msg[msg_l], "\x11", 1);       \
 msg_l++;                              \
 memcpy(&msg[msg_l], (char*)&sbuf, 2); \
 msg_l += 2;                           \
}


 int main(KIKEIB *eib) {

      char msg[4000], buffer[100], zero=0;
      int l3=3, l7=7, l10=10, l15=15, l20=20, l24=24;
      short i, msg_l, ladd=0, linc=0;
      short altht, altwd;

      // clear output buffer
      memset(msg, zero, 4000);
      msg_l = 0;

      // obtain alternate screen size
      EXEC KICKS ASSIGN ALTSCRNHT(altht) ;
      EXEC KICKS ASSIGN ALTSCRNWD(altwd) ;

      // adjust positioning based on the size we want to use
      linc = (altht - 24) / 6;
      ladd += linc; l3  += ladd;
      ladd += linc; l7  += ladd;
      ladd += linc; l10 += ladd;
      ladd += linc; l15 += ladd;
      ladd += linc; l20 += ladd;
      ladd += linc; l24 += ladd;

      // send with erase alternate...
      APPEND_MSG("\x27\x7e\xc3");

      // update sba encode parameters
      if (msg[1] == 0x7e) {
       sba_maxrow = altht;
       sba_maxcol = altwd;
       if ((altht * altwd) > 4095) sba_use14 = 1;
       }

      // 1st screen group...
      PUT_SBA(l3,1);
      APPEND_MSG("\x1d\xf8"); // protected, bright
      APPEND_MSG("KICKS");
      APPEND_MSG("\x1d\xf0"); // protected, normal
<TSO>
      APPEND_MSG("is an enhancement for TSO that ");
      APPEND_MSG("lets you run your CICS applications ");
      PUT_SBA(l3+1,2);
      APPEND_MSG("directly in TSO instead of having ");
</TSO>
<CMS>
      APPEND_MSG("is an enhancement for CMS that ");
      APPEND_MSG("lets you run your CICS applications ");
      PUT_SBA(l3+1,2);
      APPEND_MSG("directly in CMS instead of having ");
</CMS>
      APPEND_MSG("to first 'install' those apps into CICS. ");
      PUT_SBA(l3+2,2);
      APPEND_MSG("You don't even need CICS itself installed ");
      APPEND_MSG("on your machine.");

      // 2nd screen group...
      PUT_SBA(l7,2);
      APPEND_MSG("This is");
      APPEND_MSG("\x1d\xf8"); // protected, bright
      APPEND_MSG("KICKS");
      APPEND_MSG("\x1d\xf0"); // protected, normal
      APPEND_MSG("1.5.0 - ");
      APPEND_MSG("released 9/15/2014. ");
      PUT_SBA(l7+1,2);
      APPEND_MSG("A newer release of this program may be ");
      APPEND_MSG("available, see web site.");

      // 3rd screen group...
      PUT_SBA(l10,2);
      APPEND_MSG("This version of");
      APPEND_MSG("\x1d\xf8"); // protected, bright
      APPEND_MSG("KICKS");
      APPEND_MSG("\x1d\xf0"); // protected, normal
      APPEND_MSG("is intended for use only with ");
      APPEND_MSG("your non-critical ");
      PUT_SBA(l10+1,2);
      APPEND_MSG("applications. A heavy duty commercial version - aka");
      APPEND_MSG("\x1d\xf8");     // protected, bright
      APPEND_MSG("\x28\x42\xf2"); // RED
      APPEND_MSG("KICKSpro");
      APPEND_MSG("\x28\x42"); msg_l++; // null after the '42'...
      APPEND_MSG("\x1d\xf0"); // protected, normal
      APPEND_MSG("- is available ");
      PUT_SBA(l10+2,2);
      APPEND_MSG("offering the advanced features, ");
      APPEND_MSG("improved performance, enhanced reliability ");
      PUT_SBA(l10+3,2);
      APPEND_MSG("and expedited support required for ");
      APPEND_MSG("more critical work.");

       // 4th screen group...
      PUT_SBA(l15,2);
      APPEND_MSG("Please visit our web site");
      APPEND_MSG("\x1d\xf8");     // protected, bright
      APPEND_MSG("\x28\x42\xf1"); // BLUE
      APPEND_MSG("http://www.kicksfortso.com");
      APPEND_MSG("\x28\x42"); msg_l++; // null after the '42'...
      APPEND_MSG("\x1d\xf0"); // protected, normal
      APPEND_MSG("often to learn about ");
      PUT_SBA(l15+1,2);
      APPEND_MSG("the newest features, hottest issues, ");
      APPEND_MSG("tutorials (aka KooKbooK recipes), your ");
      PUT_SBA(l15+2,2);
      APPEND_MSG("support and upgrade options and ");
      APPEND_MSG("our latest promotions.");

      // 5th screen group
      PUT_SBA(l20,2);
      APPEND_MSG("Use of");
      APPEND_MSG("\x1d\xf8"); // protected, bright
      APPEND_MSG("KICKS");
      APPEND_MSG("\x1d\xf0"); // protected, normal
      APPEND_MSG("is in all cases subject to license. ");
      APPEND_MSG("\x1d\xf0");     // protected, normal
      APPEND_MSG("\x28\x41\xf4"); // underscore
      APPEND_MSG("Press PF2 now");
      APPEND_MSG("\x28\x41"); msg_l++; // null after the '41'...
      APPEND_MSG("\x1d\xf0"); // protected, normal
      APPEND_MSG("to review ");
      PUT_SBA(l20+1,2);
      APPEND_MSG("a copy of the license applicable to this ");
      APPEND_MSG("copy of KICKS.");

      // final screen group (bottom line of screen)
      PUT_SBA(l24,2);
      APPEND_MSG("Press Clear (or PF3) to return to the ");
      APPEND_MSG("block color letters screen");

      // drop in a cursor...
      PUT_SBA(l24,79);
      APPEND_MSG("\x13");

      // go into send/receive loop
      while (1) {

        // send message
        // -- note we MUST specify length, as default length
        // --      will be strlen(msg), but msg may (will!)
        // --      contain nulls so strlen will not be right!
        EXEC KICKS SEND TEXT
          FROM(msg) LENGTH(msg_l)
          STRFIELD
          NOHANDLE
        ;
        // get reply (conversational)
        EXEC KICKS RECEIVE NOHANDLE ;

        // check for PF3 (or CLEAR)
        if((eib->eibaid == KIKPF3) || (eib->eibaid == KIKCLEAR)) break;

        // check for anything else other than PF2
        if (eib->eibaid != KIKPF2) continue;

        // link to license display/print
        EXEC KICKS LINK PROGRAM("KSGMLIC") NOHANDLE ;

       } // end 'while (1)'...

      // xctl back to main screen
      EXEC KICKS XCTL PROGRAM("KSGMPGM") NOHANDLE ;

      // crash if XCTL fails...
      EXEC KICKS ABEND ;
 }
/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGX)
 ENTRY @@KSTRT
 NAME  KSGMHLP(R)
/*
//
