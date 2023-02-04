//TESTBRR JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTBRR EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTBRR.

      *///////////////////////////////////////////////////////////////
      * 'KICKS for TSO' is a product to deliver 'CICS like'
      * functionality in MVS/TSO. CICS functionality is delivered
      * at the source code level, not at the object code level.
      * Applications must be recompiled and the recompiled programs
      * are not compatible with any known version of 'real' CICS.
      *
      * 'KICKS for TSO'
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      * test harness for use with kedf
      * rrds browse, readprev, readnext, read

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN   PIC X(23) VALUE 'TESTBRR WORKING STORAGE'.
       77  KEY77      PIC S9(8) COMP VALUE +1.
       77  TEST-NUM   PIC 99    VALUE 0.
       77  AID77      PIC X     VALUE SPACE.
       77  I          PIC S9(8) COMP VALUE +0.
       77  HOME       PIC S9(8) COMP VALUE +0.
       77  RECL77     PIC S9(4) COMP VALUE +0.
       77  RESP77     PIC S9(4) COMP VALUE +0.
       77  NUM77      PIC S9(8) COMP VALUE +0.
       77  REC77      PIC X(80) VALUE SPACES.

       01  EXPECTING  PIC 9 VALUE 0.
           88 NOT-EXPECTING     VALUE 0.
           88 EXPECTING-SUCESSS VALUE 1.
           88 EXPECTING-FAILURE VALUE 2.

       01  ERR1-MSG.
           05 ERR1-WHO PIC X(8).
           05 FILLER PIC X(12) VALUE 'TEST NUMBER '.
           05 ERR1-TN PIC Z9.
           05 FILLER PIC X(32) VALUE ' EXPECTING FAILURE, GOT SUCCESS!'.
       01  ERR1-MSGL PIC S9(4) COMP VALUE +54.

       01  ERR2-MSG.
           05 ERR2-WHO PIC X(8).
           05 FILLER PIC X(12) VALUE 'TEST NUMBER '.
           05 ERR2-TN PIC Z9.
           05 FILLER PIC X(32) VALUE ' EXPECTING SUCCESS, GOT FAILURE!'.
       01  ERR2-MSGL PIC S9(4) COMP VALUE +54.

       01  BAD-PF-MSG PIC X(8)  VALUE 'BAD PF  '.
       01  DONE-MSG   PIC X(8)  VALUE 'DONE    '.
       01  DONE-LOG.
           05  DONE-LOG-PGM PIC X(8).
           05  FILLER       PIC X(4) VALUE 'DONE'.
       01  PF-MSG.
         02  PF-MSG0  PIC X(79) VALUE 'RRDS browse test (use w/KEDF)'.
         02  PF-MSG1.
           05  FILLER PIC X(17) VALUE 'PF1 - return trn '.
           05  FILLER PIC X(13) VALUE 'PF2 - ENDBR  '.
           05  FILLER PIC X(17) VALUE 'PF3 - STARTBR lo '.
           05  FILLER PIC X(23) VALUE 'PF4 - STARTBR mid(ne) '.
           05  FILLER PIC X(9)  VALUE SPACES.
         02  PF-MSG2.
           05  FILLER PIC X(23) VALUE 'PF5 - STARTBR mid(eq) '.
           05  FILLER PIC X(17) VALUE 'PF6 - STARTBR hi '.
           05  FILLER PIC X(15) VALUE 'PF7 - READPREV '.
           05  FILLER PIC X(15) VALUE 'PF8 - READNEXT '.
           05  FILLER PIC X(9)  VALUE SPACES.
         02  PF-MSG3.
           05  FILLER PIC X(11) VALUE 'PF9 - READ '.
           05  FILLER PIC X(12) VALUE 'PF10 -      '.
           05  FILLER PIC X(16) VALUE 'PF11 - script 1 '.
           05  FILLER PIC X(12) VALUE 'PF12 - quit '.

       COPY DFHAID.
      *01  DFHAID COPY DFHAID.

       PROCEDURE DIVISION.

       DO-IT-AGAIN.
           MOVE 0 TO EXPECTING.
           EXEC CICS
            SEND TEXT FROM(PF-MSG) LENGTH(288) ERASE CURSOR(HOME)
           END-EXEC.
           EXEC CICS RECEIVE END-EXEC.
           MOVE EIBAID TO AID77.

       PF1.
      *    PF1  =
           IF EIBAID NOT EQUAL DFHPF1 GO TO PF2.
           EXEC CICS RETURN TRANSID('TEST') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF2.
      *    PF2  =  ENDBR
           IF EIBAID NOT EQUAL DFHPF2 GO TO PF3.
           PERFORM ENDBR-1.
           GO TO DO-IT-AGAIN.

       PF3.
      *    PF3  =  STARTBR LO
           IF EIBAID NOT EQUAL DFHPF3 GO TO PF4.
           MOVE +1 TO KEY77.
           PERFORM STARTBR-1.
           GO TO DO-IT-AGAIN.

       PF4.
      *    PF4  =  STARTBR MID (NE)
           IF EIBAID NOT EQUAL DFHPF4 GO TO PF5.
           MOVE +19 TO KEY77.
           PERFORM STARTBR-1.
           GO TO DO-IT-AGAIN.

       PF5.
      *    PF5  =  STARTBR MID (EQ)
           IF EIBAID NOT EQUAL DFHPF5 GO TO PF6.
           MOVE +7 TO KEY77.
           PERFORM STARTBR-1.
           GO TO DO-IT-AGAIN.

       PF6.
      *    PF6  =  STARTBR HI
           IF EIBAID NOT EQUAL DFHPF6 GO TO PF7.
           MOVE -1 TO KEY77.
           PERFORM STARTBR-1.
           GO TO DO-IT-AGAIN.

       PF7.
      *    PF7  =  READPREV
           IF EIBAID NOT EQUAL DFHPF7 GO TO PF8.
           PERFORM READPREV-1.
           GO TO DO-IT-AGAIN.

       PF8.
      *    PF8  = READNEXT
           IF EIBAID NOT EQUAL DFHPF8 GO TO PF9.
           PERFORM READNEXT-1.
           GO TO DO-IT-AGAIN.

       PF9.
      *    PF9  =  READ
           IF EIBAID NOT EQUAL DFHPF9 GO TO PF10.
           PERFORM READ-1.
           GO TO DO-IT-AGAIN.

       PF10.
      *    PF10 =
           IF EIBAID NOT EQUAL DFHPF10 GO TO PF11.
           GO TO DO-IT-AGAIN.

       PF11.
      *    PF11 =
           IF EIBAID NOT EQUAL DFHPF11 GO TO PF12.
           GO TO SCRIPT-1.

       PF12.
      *    PF12 =  QUIT
           IF EIBAID NOT EQUAL DFHPF12 GO TO UNKNOW-AID.
           MOVE WS-BEGIN TO DONE-LOG-PGM.
           EXEC CICS LINK PROGRAM('KLOGIT')
            COMMAREA(DONE-LOG) LENGTH(12)
           END-EXEC.
      * continuing conversational so release files before return
           EXEC CICS SYNCPOINT END-EXEC.
           EXEC CICS XCTL PROGRAM('TESTPGM') END-EXEC.
      *    GO TO DO-IT-AGAIN.

       UNKNOW-AID.
           IF EIBTRMID NOT EQUAL 'CRLP'
            EXEC CICS
             SEND TEXT FROM(BAD-PF-MSG) LENGTH(8) ERASE CURSOR(HOME)
            END-EXEC
            EXEC CICS DELAY INTERVAL(1) END-EXEC
           ELSE
            EXEC CICS ABEND ABCODE('BARF') NODUMP END-EXEC.
           GO TO DO-IT-AGAIN.

       SCRIPT-1.
           MOVE 0 TO TEST-NUM.
      * 1-- startbr low
           MOVE +1 TO KEY77.
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM STARTBR-1.
      * 2-- 10 readnext's (ends with ENDFILE)
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READNEXT-1 VARYING I FROM +1 BY +1 UNTIL I > 15.
      * 3-- 3 readprev's
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READPREV-1 VARYING I FROM +1 BY +1 UNTIL I > 3.
      * 4-- another endbr
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM ENDBR-1.
      * 5-- startbr hi
           MOVE -1 TO KEY77.
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM STARTBR-1.
      * 6-- 10 readprev's (ends with ENDFILE)
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READPREV-1 VARYING I FROM +1 BY +1 UNTIL I > 15.
      * 7-- 3 readnext's
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READNEXT-1 VARYING I FROM +1 BY +1 UNTIL I > 3.
      * 8-- another endbr
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM ENDBR-1.
      * 9-- back to menu
           GO TO DO-IT-AGAIN.


       STARTBR-1.
           EXEC CICS
            STARTBR FILE('TSTRRDS')
                    RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       ENDBR-1.
           EXEC CICS
              ENDBR FILE('TSTRRDS')
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       READ-1.
           MOVE +80 TO RECL77.
           EXEC CICS
               READ FILE('TSTRRDS') EQUAL
                    INTO(REC77) LENGTH(RECL77)
                    RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       READ-UPDATE-1.
           MOVE +80 TO RECL77.
           EXEC CICS
               READ FILE('TSTRRDS') EQUAL
                    INTO(REC77) LENGTH(RECL77)
             UPDATE RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       READNEXT-1.
           MOVE +80 TO RECL77.
           EXEC CICS
           READNEXT FILE('TSTRRDS')
                    INTO(REC77) LENGTH(RECL77)
                    RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           IF RESP77 = DFHRESP(ENDFILE) MOVE 0 TO RESP77.
           PERFORM NOTE-UNEXPECTED.

       READPREV-1.
           MOVE +80 TO RECL77.
           EXEC CICS
           READPREV FILE('TSTRRDS')
                    INTO(REC77) LENGTH(RECL77)
                    RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           IF RESP77 = DFHRESP(ENDFILE) MOVE 0 TO RESP77.
           PERFORM NOTE-UNEXPECTED.

       WRITE-1.
           EXEC CICS
              WRITE FILE('TSTRRDS')
                    FROM(REC77) LENGTH(80)
                    RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       REWRITE-1.
           EXEC CICS
            REWRITE FILE('TSTRRDS')
                    FROM(REC77) LENGTH(80)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       DELETE-1.
           EXEC CICS
             DELETE FILE('TSTRRDS')
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       DELETE-2.
           MOVE +0 TO NUM77.
           EXEC CICS
             DELETE FILE('TSTRRDS')
                    RIDFLD(KEY77) RRN
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       UNLOCK-1.
           EXEC CICS
             UNLOCK FILE('TSTRRDS')
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       NOTE-UNEXPECTED.
           MOVE TEST-NUM TO ERR1-TN,  ERR2-TN.
           MOVE WS-BEGIN TO ERR1-WHO, ERR2-WHO.
           IF EXPECTING-FAILURE AND RESP77 = 0
            EXEC CICS LINK PROGRAM('KLOGIT')
             COMMAREA(ERR1-MSG) LENGTH(ERR1-MSGL)
            END-EXEC
            IF EIBTRMID NOT EQUAL 'CRLP'
             EXEC CICS
              SEND TEXT FROM(ERR1-MSG) LENGTH(ERR1-MSGL)
               ERASE CURSOR(HOME)
             END-EXEC
             EXEC CICS DELAY INTERVAL(1) END-EXEC
             EXEC CICS RECEIVE END-EXEC
            ELSE NEXT SENTENCE.
           IF EXPECTING-SUCESSS AND RESP77 NOT = 0
            EXEC CICS LINK PROGRAM('KLOGIT')
             COMMAREA(ERR2-MSG) LENGTH(ERR2-MSGL)
            END-EXEC
            IF EIBTRMID NOT EQUAL 'CRLP'
             EXEC CICS
              SEND TEXT FROM(ERR2-MSG) LENGTH(ERR2-MSGL)
               ERASE CURSOR(HOME)
             END-EXEC
             EXEC CICS DELAY INTERVAL(1) END-EXEC
             EXEC CICS RECEIVE END-EXEC
            ELSE NEXT SENTENCE.
           MOVE TALLY TO TALLY.

       END-OF-IT.

/*
//LKED.SYSLMOD DD DSN=K.U.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTBRR
 NAME  TESTBRR(R)
/*
//
