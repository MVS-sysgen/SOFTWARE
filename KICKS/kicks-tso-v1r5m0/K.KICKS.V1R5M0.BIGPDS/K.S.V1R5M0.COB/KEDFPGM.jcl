//KEDFPGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KEDFPGM EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. KEDFPGM.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      *///////////////////////////////////////////////////////////////
      * KEDFPGM (tranid KEDF) is control for the Exec Debug Facility,
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'KEDFPGM  WORKING STORAGE'.
       77  WS-RESP             PIC S9(4)  COMP.
       77  WS-TBL-IDX          PIC S9(4)  COMP.
       77  WS-CURSOR           PIC S9(8)  COMP VALUE +0.
       77  ROW                 PIC S9(4)  COMP.
       77  COL                 PIC S9(4)  COMP.
       77  WS-ABSTIME          PIC S9(15) COMP-3.
<CB2>
       77  WS-ADDR-TABLE       PIC S9(8)  COMP.
       77  WS-PNTR-TABLE REDEFINES WS-ADDR-TABLE USAGE POINTER.
</CB2>

       01  SUBS-COMMAREA.
           05  RC              PIC S9(4)  COMP.

       01  DONE-MSG.
           05  FILLER          PIC X(13)  VALUE '     KEDF is '.
           05  DM-ONOFF        PIC X(3)   VALUE SPACES.

       01  IM-FLENGTH          PIC S9(8)  COMP VALUE +30.
       01  INPUT-MSG.
           05  FILLER          PIC X(4).
           05  FILLER          PIC X.
           05  IM-REST         PIC X(25).

      * some (sub)strings for command processing
       01  WS-MAYBE.
           05  MAYBE           PIC X(25).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE2   PIC X(2).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE3   PIC X(3).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE4   PIC X(4).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE5   PIC X(5).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE6   PIC X(6).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE7   PIC X(7).

       01  DT-WORK.
           05  TIME-WORK       PIC 99B99B99.
           05  FILLER          PIC XX     VALUE SPACES.
           05  DATE-WORK       PIC X(8).

       01  WS-TABLE.
           05  TBL-VRM         PIC S9(8)  COMP.
           05  TBL-ENTRY OCCURS 100.
               10  TBL-FN      PIC S9(4)  COMP.
               10  TBL-FLAG    PIC S9(4)  COMP.

       COPY KEDMAP.

       COPY KIKAID.
       COPY KIKBMSCA.

       LINKAGE SECTION.

       01  KIKCOMMAREA.
           05  TBL-VRM         PIC S9(8)  COMP.
           05  TBL-ENTRY OCCURS 100.
               10  TBL-FN      PIC S9(4)  COMP.
               10  TBL-FLAG    PIC S9(4)  COMP.

<NCB2>
       01  CELLS.
           05  FILLER          PIC S9(8)  COMP.
           05  BLL-TBL         PIC S9(8)  COMP.
</NCB2>

       01  THE-TABLE.
           05  TBL-VRM         PIC S9(8)  COMP.
           05  TBL-ENTRY OCCURS 100.
               10  TBL-FN      PIC S9(4)  COMP.
               10  TBL-FLAG    PIC S9(4)  COMP.

       PROCEDURE DIVISION.
           IF EIBCALEN > 0 THEN GO TO NOT-FIRST-TIME.

       FIRST-TIME.
           EXEC KICKS
             RECEIVE
             INTO(INPUT-MSG) RESP(RC)
             FLENGTH(IM-FLENGTH) MAXFLENGTH(IM-FLENGTH)
           END-EXEC.
<CB2>
           INSPECT
</CB2>
<NCB2>
           EXAMINE
</NCB2>
            INPUT-MSG REPLACING ALL LOW-VALUES BY SPACES.
           MOVE IM-REST TO WS-MAYBE.

           IF IM-FLENGTH > 8 AND WS-MAYBE4 = 'ON/S' THEN
      * ON/S means turn on with source trace enabled
            PERFORM LOAD-TABLE
            MOVE 0 TO TBL-FLAG OF WS-TABLE (51)
            PERFORM SAVE-TABLE
             EXEC KICKS
                 LINK PROGRAM('KEDFON')
                 COMMAREA(SUBS-COMMAREA)
             END-EXEC
             GO TO LAST-TIME.
           IF IM-FLENGTH > 6 AND WS-MAYBE2 = 'ON' THEN
      * ON wo /S means turn on with source trace disabled
            PERFORM LOAD-TABLE
            MOVE 1 TO TBL-FLAG OF WS-TABLE (51)
            PERFORM SAVE-TABLE
             EXEC KICKS
                 LINK PROGRAM('KEDFON')
                 COMMAREA(SUBS-COMMAREA)
             END-EXEC
             GO TO LAST-TIME.
           IF IM-FLENGTH > 7 AND WS-MAYBE3 = 'OFF' THEN
             EXEC KICKS
                 LINK PROGRAM('KEDFOFF')
                 COMMAREA(SUBS-COMMAREA)
             END-EXEC
             GO TO LAST-TIME.

           PERFORM LOAD-TABLE.
           GO TO EVERY-TIME.

       NOT-FIRST-TIME.
           MOVE KIKCOMMAREA TO WS-TABLE.
           EXEC KICKS
             RECEIVE MAP('KEDMAPP') MAPSET('KEDMAP') RESP(RC)
           END-EXEC.
           MOVE EIBCPOSN TO WS-CURSOR.
           IF EIBAID = KIKCLEAR GO TO LAST-TIME.
           IF EIBAID = KIKENTER OR EIBAID = KIKPF3
              PERFORM SAVE-TABLE
              GO TO LAST-TIME.
           IF EIBAID = KIKPF4 PERFORM TOGGLE-EDF.
           IF EIBAID = KIKPF5 PERFORM TOGGLE-ONE-ITEM.
           IF EIBAID = KIKPF6 PERFORM UNSET-ALL.
           IF EIBAID = KIKPF7 PERFORM SET-ALL.

       EVERY-TIME.
      * -- except last time that is...
           PERFORM FILL-IN-MAP.
           EXEC KICKS
             SEND MAP('KEDMAPP') MAPSET('KEDMAP')
               CURSOR(WS-CURSOR) ERASE
           END-EXEC.
           EXEC KICKS
             RETURN TRANSID('KEDF')
              COMMAREA(WS-TABLE)
           END-EXEC.

       LAST-TIME.
           EXEC KICKS
               LINK PROGRAM('KEDFSTA')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           IF RC = 0 THEN
            MOVE 'off' TO DM-ONOFF
           ELSE
            MOVE 'on ' TO DM-ONOFF.
           MOVE +0 TO WS-CURSOR
           EXEC KICKS
             SEND TEXT FROM(DONE-MSG)
             ERASE CURSOR(WS-CURSOR)
           END-EXEC
           EXEC KICKS RETURN END-EXEC.


       LOAD-TABLE SECTION.
<NCB2>
           EXEC KICKS
             LOAD PROGRAM('KEDFILTR')
             SET(BLL-TBL)
             HOLD
             RESP(WS-RESP)
           END-EXEC.
</NCB2>
<CB2>
           EXEC KICKS
             LOAD PROGRAM('KEDFILTR')
             SET(WS-ADDR-TABLE)
             HOLD
             RESP(WS-RESP)
           END-EXEC.
           SET ADDRESS OF THE-TABLE TO WS-PNTR-TABLE.
</CB2>
           IF WS-RESP NOT = KIKRESP(NORMAL)
            MOVE 'BAD FILTER LOAD ' TO DONE-MSG
            EXEC KICKS
              SEND TEXT FROM(DONE-MSG) ERASE
            END-EXEC
            EXEC KICKS RETURN END-EXEC.
           IF TBL-VRM OF THE-TABLE NOT EQUAL KIK-V1
               EXEC KICKS ABEND ABCODE('VERS') END-EXEC.
           MOVE THE-TABLE TO WS-TABLE.
           EXEC KICKS
               LINK PROGRAM('KEDFSTA')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           IF RC = 0 THEN
            MOVE 0 TO TBL-FLAG OF WS-TABLE (100)
           ELSE
            MOVE 1 TO TBL-FLAG OF WS-TABLE (100).
      *    1503 = (19-1)*80 + (64-1) -- put cursor at 19, 64
           MOVE +1503 TO WS-CURSOR.
       LOAD-TABLE-EXIT.
           EXIT.


       SAVE-TABLE SECTION.
<NCB2>
           EXEC KICKS
             LOAD PROGRAM('KEDFILTR')
             SET(BLL-TBL)
             HOLD
             NOHANDLE
           END-EXEC.
</NCB2>
<CB2>
           EXEC KICKS
             LOAD PROGRAM('KEDFILTR')
             SET(WS-ADDR-TABLE)
             HOLD
             NOHANDLE
           END-EXEC.
           SET ADDRESS OF THE-TABLE TO WS-PNTR-TABLE.
</CB2>

      *
      *    Note we must not move ws-table back to table as
      *    below because table doesn't really have 100
      *    elements, so this move would overlay storage!
      *
      *    MOVE WS-TABLE TO THE-TABLE.
      *
      *    instead we copy the elements one at a time until
      *    we get to the last one.
      *
           MOVE +0 TO WS-TBL-IDX.
       SAVE-TABLE-LOOP.
           ADD +1 TO WS-TBL-IDX.
           IF WS-TBL-IDX > 100 THEN GO TO SAVE-TABLE-LOOP-END.
           IF TBL-FN OF WS-TABLE (WS-TBL-IDX) EQUAL +0
             THEN GO TO SAVE-TABLE-LOOP-END.
           MOVE TBL-FLAG OF WS-TABLE (WS-TBL-IDX) TO
                TBL-FLAG OF THE-TABLE (WS-TBL-IDX).
           GO TO SAVE-TABLE-LOOP.
       SAVE-TABLE-LOOP-END.
           IF TBL-FLAG OF WS-TABLE (100) = 0 THEN
             EXEC KICKS
                 LINK PROGRAM('KEDFOFF')
                 COMMAREA(SUBS-COMMAREA)
             END-EXEC
           ELSE
             EXEC KICKS
                 LINK PROGRAM('KEDFON')
                 COMMAREA(SUBS-COMMAREA)
             END-EXEC.
       SAVE-TABLE-EXIT.
           EXIT.


       SET-ALL SECTION.
           MOVE +0 TO WS-TBL-IDX.
       SET-ALL-LOOP.
           ADD +1 TO WS-TBL-IDX.
           IF WS-TBL-IDX > 100 THEN GO TO SET-ALL-EXIT.
           IF TBL-FN OF WS-TABLE (WS-TBL-IDX) EQUAL +0
             THEN GO TO SET-ALL-EXIT.
           MOVE +1 TO TBL-FLAG OF WS-TABLE (WS-TBL-IDX).
           GO TO SET-ALL-LOOP.
       SET-ALL-EXIT.
           EXIT.


       UNSET-ALL SECTION.
           MOVE +0 TO WS-TBL-IDX.
       UNSET-ALL-LOOP.
           ADD +1 TO WS-TBL-IDX.
           IF WS-TBL-IDX > 100 THEN GO TO UNSET-ALL-EXIT.
           IF TBL-FN OF WS-TABLE (WS-TBL-IDX) EQUAL +0
             THEN GO TO UNSET-ALL-EXIT.
           MOVE +0 TO TBL-FLAG OF WS-TABLE (WS-TBL-IDX).
           GO TO UNSET-ALL-LOOP.
       UNSET-ALL-EXIT.
           EXIT.


       FILL-IN-MAP SECTION.
           MOVE LOW-VALUES TO KEDMAPPO.
           MOVE 'KEDF (1.5.0) is  ' TO R1C1O.
           IF TBL-FLAG OF WS-TABLE (100) = 0 THEN
            MOVE 'OFF ' TO R1C20O
            MOVE 'ON  ' TO R1C36O
           ELSE
            MOVE 'ON  ' TO R1C20O
            MOVE 'OFF ' TO R1C36O.
           EXEC KICKS ASKTIME ABSTIME(WS-ABSTIME) END-EXEC.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             TIME(TIME-WORK) TIMESEP(':')
           END-EXEC.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             MMDDYY(DATE-WORK) DATESEP('/')
           END-EXEC.
           MOVE DT-WORK TO R1C63O.

           IF TBL-FLAG OF WS-TABLE (1) > 0 THEN
               MOVE KIKTURQ TO R7C35C ELSE MOVE KIKGREEN TO R7C35C.
           IF TBL-FLAG OF WS-TABLE (2) > 0 THEN
               MOVE KIKTURQ TO R13C63C ELSE MOVE KIKGREEN TO R13C63C.
           IF TBL-FLAG OF WS-TABLE (3) > 0 THEN
               MOVE KIKTURQ TO R15C63C ELSE MOVE KIKGREEN TO R15C63C.
           IF TBL-FLAG OF WS-TABLE (4) > 0 THEN
               MOVE KIKTURQ TO R9C35C ELSE MOVE KIKGREEN TO R9C35C.
           IF TBL-FLAG OF WS-TABLE (5) > 0 THEN
               MOVE KIKTURQ TO R14C63C ELSE MOVE KIKGREEN TO R14C63C.
           IF TBL-FLAG OF WS-TABLE (6) > 0 THEN
               MOVE KIKTURQ TO R7C63C ELSE MOVE KIKGREEN TO R7C63C.
           IF TBL-FLAG OF WS-TABLE (7) > 0 THEN
               MOVE KIKTURQ TO R9C20C ELSE MOVE KIKGREEN TO R9C20C.
           IF TBL-FLAG OF WS-TABLE (8) > 0 THEN
               MOVE KIKTURQ TO R16C20C ELSE MOVE KIKGREEN TO R16C20C.
           IF TBL-FLAG OF WS-TABLE (9) > 0 THEN
               MOVE KIKTURQ TO R13C20C ELSE MOVE KIKGREEN TO R13C20C.
           IF TBL-FLAG OF WS-TABLE (10) > 0 THEN
               MOVE KIKTURQ TO R7C20C ELSE MOVE KIKGREEN TO R7C20C.
           IF TBL-FLAG OF WS-TABLE (11) > 0 THEN
               MOVE KIKTURQ TO R15C20C ELSE MOVE KIKGREEN TO R15C20C.
           IF TBL-FLAG OF WS-TABLE (12) > 0 THEN
               MOVE KIKTURQ TO R14C20C ELSE MOVE KIKGREEN TO R14C20C.
           IF TBL-FLAG OF WS-TABLE (13) > 0 THEN
               MOVE KIKTURQ TO R10C20C ELSE MOVE KIKGREEN TO R10C20C.
           IF TBL-FLAG OF WS-TABLE (14) > 0 THEN
               MOVE KIKTURQ TO R11C20C ELSE MOVE KIKGREEN TO R11C20C.
           IF TBL-FLAG OF WS-TABLE (15) > 0 THEN
               MOVE KIKTURQ TO R8C20C ELSE MOVE KIKGREEN TO R8C20C.
           IF TBL-FLAG OF WS-TABLE (16) > 0 THEN
               MOVE KIKTURQ TO R12C20C ELSE MOVE KIKGREEN TO R12C20C.
           IF TBL-FLAG OF WS-TABLE (17) > 0 THEN
               MOVE KIKTURQ TO R9C4C ELSE MOVE KIKGREEN TO R9C4C.
           IF TBL-FLAG OF WS-TABLE (18) > 0 THEN
               MOVE KIKTURQ TO R8C4C ELSE MOVE KIKGREEN TO R8C4C.
           IF TBL-FLAG OF WS-TABLE (19) > 0 THEN
               MOVE KIKTURQ TO R7C4C ELSE MOVE KIKGREEN TO R7C4C.
           IF TBL-FLAG OF WS-TABLE (20) > 0 THEN
               MOVE KIKTURQ TO R10C49C ELSE MOVE KIKGREEN TO R10C49C.
           IF TBL-FLAG OF WS-TABLE (21) > 0 THEN
               MOVE KIKTURQ TO R14C49C ELSE MOVE KIKGREEN TO R14C49C.
           IF TBL-FLAG OF WS-TABLE (22) > 0 THEN
               MOVE KIKTURQ TO R11C49C ELSE MOVE KIKGREEN TO R11C49C.
           IF TBL-FLAG OF WS-TABLE (23) > 0 THEN
               MOVE KIKTURQ TO R13C49C ELSE MOVE KIKGREEN TO R13C49C.
           IF TBL-FLAG OF WS-TABLE (24) > 0 THEN
               MOVE KIKTURQ TO R12C49C ELSE MOVE KIKGREEN TO R12C49C.
           IF TBL-FLAG OF WS-TABLE (25) > 0 THEN
               MOVE KIKTURQ TO R7C49C ELSE MOVE KIKGREEN TO R7C49C.
           IF TBL-FLAG OF WS-TABLE (26) > 0 THEN
               MOVE KIKTURQ TO R8C35C ELSE MOVE KIKGREEN TO R8C35C.
           IF TBL-FLAG OF WS-TABLE (27) > 0 THEN
               MOVE KIKTURQ TO R11C35C ELSE MOVE KIKGREEN TO R11C35C.
           IF TBL-FLAG OF WS-TABLE (28) > 0 THEN
               MOVE KIKTURQ TO R15C35C ELSE MOVE KIKGREEN TO R15C35C.
           IF TBL-FLAG OF WS-TABLE (29) > 0 THEN
               MOVE KIKTURQ TO R11C4C ELSE MOVE KIKGREEN TO R11C4C.
           IF TBL-FLAG OF WS-TABLE (30) > 0 THEN
               MOVE KIKTURQ TO R12C4C ELSE MOVE KIKGREEN TO R12C4C.
           IF TBL-FLAG OF WS-TABLE (31) > 0 THEN
               MOVE KIKTURQ TO R13C4C ELSE MOVE KIKGREEN TO R13C4C.
           IF TBL-FLAG OF WS-TABLE (32) > 0 THEN
               MOVE KIKTURQ TO R16C35C ELSE MOVE KIKGREEN TO R16C35C.
           IF TBL-FLAG OF WS-TABLE (33) > 0 THEN
               MOVE KIKTURQ TO R8C63C ELSE MOVE KIKGREEN TO R8C63C.
           IF TBL-FLAG OF WS-TABLE (34) > 0 THEN
               MOVE KIKTURQ TO R10C63C ELSE MOVE KIKGREEN TO R10C63C.
           IF TBL-FLAG OF WS-TABLE (35) > 0 THEN
               MOVE KIKTURQ TO R9C63C ELSE MOVE KIKGREEN TO R9C63C.
           IF TBL-FLAG OF WS-TABLE (36) > 0 THEN
               MOVE KIKTURQ TO R11C63C ELSE MOVE KIKGREEN TO R11C63C.
           IF TBL-FLAG OF WS-TABLE (37) > 0 THEN
               MOVE KIKTURQ TO R9C49C ELSE MOVE KIKGREEN TO R9C49C.
           IF TBL-FLAG OF WS-TABLE (38) > 0 THEN
               MOVE KIKTURQ TO R8C49C ELSE MOVE KIKGREEN TO R8C49C.

           IF TBL-FLAG OF WS-TABLE (40) > 0 THEN
               MOVE KIKTURQ TO R13C35C ELSE MOVE KIKGREEN TO R13C35C.
           IF TBL-FLAG OF WS-TABLE (41) > 0 THEN
               MOVE KIKTURQ TO R17C20C ELSE MOVE KIKGREEN TO R17C20C.
           IF TBL-FLAG OF WS-TABLE (42) > 0 THEN
               MOVE KIKTURQ TO R14C35C ELSE MOVE KIKGREEN TO R14C35C.
           IF TBL-FLAG OF WS-TABLE (43) > 0 THEN
               MOVE KIKTURQ TO R10C35C ELSE MOVE KIKGREEN TO R10C35C.
           IF TBL-FLAG OF WS-TABLE (44) > 0 THEN
               MOVE KIKTURQ TO R12C35C ELSE MOVE KIKGREEN TO R12C35C.
           IF TBL-FLAG OF WS-TABLE (45) > 0 THEN
               MOVE KIKTURQ TO R16C49C ELSE MOVE KIKGREEN TO R16C49C.
           IF TBL-FLAG OF WS-TABLE (46) > 0 THEN
               MOVE KIKTURQ TO R17C49C ELSE MOVE KIKGREEN TO R17C49C.
           IF TBL-FLAG OF WS-TABLE (47) > 0 THEN
               MOVE KIKTURQ TO R16C63C ELSE MOVE KIKGREEN TO R16C63C.
           IF TBL-FLAG OF WS-TABLE (48) > 0 THEN
               MOVE KIKTURQ TO R15C4C ELSE MOVE KIKGREEN TO R15C4C.
           IF TBL-FLAG OF WS-TABLE (49) > 0 THEN
               MOVE KIKTURQ TO R16C4C ELSE MOVE KIKGREEN TO R16C4C.
           IF TBL-FLAG OF WS-TABLE (50) > 0 THEN
               MOVE KIKTURQ TO R17C4C ELSE MOVE KIKGREEN TO R17C4C.
           IF TBL-FLAG OF WS-TABLE (51) > 0 THEN
               MOVE KIKTURQ TO R19C20C ELSE MOVE KIKGREEN TO R19C20C.

       FILL-IN-MAP-EXIT.
           EXIT.


       TOGGLE-EDF SECTION.
           IF TBL-FLAG OF WS-TABLE (100) = 0 THEN
            MOVE 1 TO TBL-FLAG OF WS-TABLE (100)
           ELSE
            MOVE 0 TO TBL-FLAG OF WS-TABLE (100).
       TOGGLE-EDF-EXIT.
           EXIT.


       TOGGLE-ONE-ITEM SECTION.
           MOVE 0 TO WS-TBL-IDX.
           DIVIDE WS-CURSOR BY 80
             GIVING ROW
             REMAINDER COL.
           ADD 1 TO ROW.
           ADD 1 TO COL.

           IF ROW = 7 AND COL > 35 AND COL < 43 THEN
               MOVE 1 TO WS-TBL-IDX.
           IF ROW = 13 AND COL > 63 AND COL < 80 THEN
               MOVE 2 TO WS-TBL-IDX.
           IF ROW = 15 AND COL > 63 AND COL < 74 THEN
               MOVE 3 TO WS-TBL-IDX.
           IF ROW = 9 AND COL > 35 AND COL < 42 THEN
               MOVE 4 TO WS-TBL-IDX.
           IF ROW = 14 AND COL > 63 AND COL < 80 THEN
               MOVE 5 TO WS-TBL-IDX.
           IF ROW = 7 AND COL > 63 AND COL < 71 THEN
               MOVE 6 TO WS-TBL-IDX.
           IF ROW = 9 AND COL > 20 AND COL < 25 THEN
               MOVE 7 TO WS-TBL-IDX.
           IF ROW = 16 AND COL > 20 AND COL < 26 THEN
               MOVE 8 TO WS-TBL-IDX.
           IF ROW = 13 AND COL > 20 AND COL < 28 THEN
               MOVE 9 TO WS-TBL-IDX.
           IF ROW = 7 AND COL > 20 AND COL < 27 THEN
               MOVE 10 TO WS-TBL-IDX.
           IF ROW = 15 AND COL > 20 AND COL < 27 THEN
               MOVE 11 TO WS-TBL-IDX.
           IF ROW = 14 AND COL > 20 AND COL < 28 THEN
               MOVE 12 TO WS-TBL-IDX.
           IF ROW = 10 AND COL > 20 AND COL < 29 THEN
               MOVE 13 TO WS-TBL-IDX.
           IF ROW = 11 AND COL > 20 AND COL < 29 THEN
               MOVE 14 TO WS-TBL-IDX.
           IF ROW = 8 AND COL > 20 AND COL < 26 THEN
               MOVE 15 TO WS-TBL-IDX.
           IF ROW = 12 AND COL > 20 AND COL < 28 THEN
               MOVE 16 TO WS-TBL-IDX.
           IF ROW = 9 AND COL > 4 AND COL < 14 THEN
               MOVE 17 TO WS-TBL-IDX.
           IF ROW = 8 AND COL > 4 AND COL < 13 THEN
               MOVE 18 TO WS-TBL-IDX.
           IF ROW = 7 AND COL > 4 AND COL < 15 THEN
               MOVE 19 TO WS-TBL-IDX.
           IF ROW = 10 AND COL > 49 AND COL < 54 THEN
               MOVE 20 TO WS-TBL-IDX.
           IF ROW = 14 AND COL > 49 AND COL < 54 THEN
               MOVE 21 TO WS-TBL-IDX.
           IF ROW = 11 AND COL > 49 AND COL < 54 THEN
               MOVE 22 TO WS-TBL-IDX.
           IF ROW = 13 AND COL > 49 AND COL < 56 THEN
               MOVE 23 TO WS-TBL-IDX.
           IF ROW = 12 AND COL > 49 AND COL < 57 THEN
               MOVE 24 TO WS-TBL-IDX.
           IF ROW = 7 AND COL > 49 AND COL < 55 THEN
               MOVE 25 TO WS-TBL-IDX.
           IF ROW = 8 AND COL > 35 AND COL < 43 THEN
               MOVE 26 TO WS-TBL-IDX.
           IF ROW = 11 AND COL > 35 AND COL < 41 THEN
               MOVE 27 TO WS-TBL-IDX.
           IF ROW = 15 AND COL > 35 AND COL < 43 THEN
               MOVE 28 TO WS-TBL-IDX.
           IF ROW = 11 AND COL > 4 AND COL < 14 THEN
               MOVE 29 TO WS-TBL-IDX.
           IF ROW = 12 AND COL > 4 AND COL < 15 THEN
               MOVE 30 TO WS-TBL-IDX.
           IF ROW = 13 AND COL > 4 AND COL < 15 THEN
               MOVE 31 TO WS-TBL-IDX.
           IF ROW = 16 AND COL > 35 AND COL < 45 THEN
               MOVE 32 TO WS-TBL-IDX.
           IF ROW = 8 AND COL > 63 AND COL < 75 THEN
               MOVE 33 TO WS-TBL-IDX.
           IF ROW = 10 AND COL > 63 AND COL < 72 THEN
               MOVE 34 TO WS-TBL-IDX.
           IF ROW = 9 AND COL > 63 AND COL < 73 THEN
               MOVE 35 TO WS-TBL-IDX.
           IF ROW = 11 AND COL > 63 AND COL < 76 THEN
               MOVE 36 TO WS-TBL-IDX.
           IF ROW = 9 AND COL > 49 AND COL < 55 THEN
               MOVE 37 TO WS-TBL-IDX.
           IF ROW = 8 AND COL > 49 AND COL < 54 THEN
               MOVE 38 TO WS-TBL-IDX.

           IF ROW = 13 AND COL > 35 AND COL < 46 THEN
               MOVE 40 TO WS-TBL-IDX.
           IF ROW = 17 AND COL > 20 AND COL < 35 THEN
               MOVE 41 TO WS-TBL-IDX.
           IF ROW = 14 AND COL > 35 AND COL < 43 THEN
               MOVE 42 TO WS-TBL-IDX.
           IF ROW = 10 AND COL > 35 AND COL < 39 THEN
               MOVE 43 TO WS-TBL-IDX.
           IF ROW = 12 AND COL > 35 AND COL < 39 THEN
               MOVE 44 TO WS-TBL-IDX.
           IF ROW = 16 AND COL > 49 AND COL < 58 THEN
               MOVE 45 TO WS-TBL-IDX.
           IF ROW = 17 AND COL > 49 AND COL < 57 THEN
               MOVE 46 TO WS-TBL-IDX.
           IF ROW = 16 AND COL > 63 AND COL < 76 THEN
               MOVE 47 TO WS-TBL-IDX.
           IF ROW = 15 AND COL > 4 AND COL < 15 THEN
               MOVE 48 TO WS-TBL-IDX.
           IF ROW = 16 AND COL > 4 AND COL < 13 THEN
               MOVE 49 TO WS-TBL-IDX.
           IF ROW = 17 AND COL > 4 AND COL < 14 THEN
               MOVE 50 TO WS-TBL-IDX.
           IF ROW = 19 AND COL > 20 AND COL < 33 THEN
               MOVE 51 TO WS-TBL-IDX.

           IF WS-TBL-IDX = 0 THEN GO TO TOGGLE-ONE-ITEM-EXIT.
           IF TBL-FLAG OF WS-TABLE (WS-TBL-IDX) > 0 THEN
            MOVE 0 TO TBL-FLAG OF WS-TABLE (WS-TBL-IDX)
           ELSE
            MOVE 1 TO TBL-FLAG OF WS-TABLE (WS-TBL-IDX).

      *8901234567890123456789012345678901234567890123456789012345678901
      *    replicate 'asktimes'
           MOVE TBL-FLAG OF WS-TABLE (26) TO TBL-FLAG OF WS-TABLE (39).

       TOGGLE-ONE-ITEM-EXIT.
           EXIT.
/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY KEDFPGM
 NAME  KEDFPGM(R)
/*
//
