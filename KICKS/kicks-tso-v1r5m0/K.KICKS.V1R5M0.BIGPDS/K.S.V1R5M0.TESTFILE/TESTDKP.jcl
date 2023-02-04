//TESTDKP JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTDKP EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTDKP.

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

      * test harness for use with cedf  -- VIA PATH
      * ksds direct access: read, write, delete, rewrite, unlock

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN   PIC X(23) VALUE 'TESTDKP WORKING STORAGE'.
       77  KEY77      PIC X(6)  VALUE SPACES.
       77  TEST-NUM   PIC 99    VALUE 0.
       77  AID77      PIC X     VALUE SPACE.
       77  I          PIC S9(8) COMP VALUE +0.
       77  HOME       PIC S9(8) COMP VALUE +0.
       77  RECL77     PIC S9(4) COMP VALUE +0.
       77  RESP77     PIC S9(4) COMP VALUE +0.
       77  NUM77      PIC S9(8) COMP VALUE +0.
       77  REC77      PIC X(80) VALUE SPACES.
       77  SAVREC77   PIC X(80) VALUE SPACES.

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
         02  PF-MSG0  PIC X(79)
           VALUE 'KSDS direct test w/path (use w/CEDF)'.
         02  PF-MSG1.
           05  FILLER PIC X(18) VALUE 'PF1 - return trn  '.
           05  FILLER PIC X(13) VALUE 'PF2 - READ  '.
           05  FILLER PIC X(17) VALUE 'PF3 - WRITE  '.
           05  FILLER PIC X(23) VALUE 'PF4 - DELETE'.
           05  FILLER PIC X(8) VALUE ' '.
         02  PF-MSG2.
           05  FILLER PIC X(23) VALUE 'PF5 - REWRITE  '.
           05  FILLER PIC X(17) VALUE 'PF6 - UNLOCK  '.
           05  FILLER PIC X(15) VALUE 'PF7 -   '.
           05  FILLER PIC X(21) VALUE 'PF8 - READ for update'.
           05  FILLER PIC X(3) VALUE ' '.
         02  PF-MSG3.
           05  FILLER PIC X(23) VALUE 'PF9 -   '.
           05  FILLER PIC X(17) VALUE 'PF10 -   '.
           05  FILLER PIC X(15) VALUE 'PF11 - script  '.
           05  FILLER PIC X(15) VALUE 'PF12 - quit'.

       COPY DFHAID.
      *01  DFHAID COPY DFHAID.

       PROCEDURE DIVISION.

       DO-IT-AGAIN.
           MOVE 0 TO EXPECTING.
           EXEC CICS
            SEND TEXT FROM(PF-MSG) LENGTH(307) ERASE CURSOR(HOME)
           END-EXEC.
           EXEC CICS RECEIVE END-EXEC.
           MOVE EIBAID TO AID77.

       PF1.
      *    PF1  =
           IF EIBAID NOT EQUAL DFHPF1 GO TO PF2.
           EXEC CICS RETURN TRANSID('TEST') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF2.
      *    PF2  =  READ
           IF EIBAID NOT EQUAL DFHPF2 GO TO PF3.
           PERFORM READ-1.
           GO TO DO-IT-AGAIN.

       PF3.
      *    PF3  = WRITE
           IF EIBAID NOT EQUAL DFHPF3 GO TO PF4.
           PERFORM WRITE-1.
           GO TO DO-IT-AGAIN.

       PF4.
      *    PF4  = DELETE
           IF EIBAID NOT EQUAL DFHPF4 GO TO PF5.
           PERFORM DELETE-1.
           GO TO DO-IT-AGAIN.

       PF5.
      *    PF5  = REWRITE
           IF EIBAID NOT EQUAL DFHPF5 GO TO PF6.
           PERFORM REWRITE-1.
           GO TO DO-IT-AGAIN.

       PF6.
      *    PF6  = UNLOCK
           IF EIBAID NOT EQUAL DFHPF6 GO TO PF7.
           PERFORM UNLOCK-1.
           GO TO DO-IT-AGAIN.

       PF7.
      *    PF7  =
           IF EIBAID NOT EQUAL DFHPF7 GO TO PF8.
           GO TO UNKNOW-AID.

       PF8.
      *    PF8  = READ for update
           IF EIBAID NOT EQUAL DFHPF8 GO TO PF9.
           PERFORM READ-UPDATE-1.
           GO TO DO-IT-AGAIN.

       PF9.
      *    PF9  =
           IF EIBAID NOT EQUAL DFHPF9 GO TO PF10.
           GO TO UNKNOW-AID.

       PF10.
      *    PF10 =
           IF EIBAID NOT EQUAL DFHPF10 GO TO PF11.
           GO TO UNKNOW-AID.

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
      * 1--- read record THREE (key = three). should succeed
           MOVE 'THREE ' TO KEY77.
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READ-1.
      * 2--- delete record THREE (key = three). should fail
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           PERFORM DELETE-1.
      * 3--- rewrite record THREE (key = three). should fail
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           PERFORM REWRITE-1.
      * 4--- unlock record THREE (key = three). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM UNLOCK-1.
      * 5--- read/update record THREEA (key = threea). should succeed
           MOVE 'THREEA' TO KEY77.
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READ-UPDATE-1.
      * 6--- delete record THREEA (key = threea). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           MOVE REC77 TO SAVREC77.
           PERFORM DELETE-1.
      * 7--- rewrite record THREEA (key = threea). should fail
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           PERFORM REWRITE-1.
      * 8--- unlock record THREEA (key = threea). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM UNLOCK-1.
      * 9--- read record THREEA (key = threea). should fail
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           PERFORM READ-1.
      * 10-- read/update record THREEB (key = threeb). should succeed
           MOVE 'THREEB' TO KEY77.
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READ-UPDATE-1.
      * 11-- rewrite record THREEB (key = threeb). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM REWRITE-1.
      * 12-- unlock record THREEB (key = threeb). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM UNLOCK-1.
      * 13-- read/update record THREEB (key = threeb). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM READ-UPDATE-1.
      * 14-- read/update record THREEB (key = threeb). should fail
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           PERFORM READ-UPDATE-1.
      * 15-- rewrite record THREEB (key = threeb). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM REWRITE-1.
      * 16-- unlock record THREEB (key = threeb). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           PERFORM UNLOCK-1.
      * 17-- WRITE record THREEA (key = threea). should fail
      *                                          (int key <> ridfld)
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           MOVE 'THREEA' TO KEY77.
           PERFORM WRITE-1.
      * 18-- WRITE record THREEA (key = threea). should succeed
           ADD 1 TO TEST-NUM. MOVE 1 TO EXPECTING.
           MOVE SAVREC77 TO REC77.
           PERFORM WRITE-1.
      * 19-- WRITE record THREEA (key = threea). should fail (dup)
           ADD 1 TO TEST-NUM. MOVE 2 TO EXPECTING.
           PERFORM WRITE-1.
      * ---- that's all folks...
           GO TO DO-IT-AGAIN.

       STARTBR-1.
           EXEC CICS
            STARTBR FILE('TSTKSDP')
                    RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       ENDBR-1.
           EXEC CICS
              ENDBR FILE('TSTKSDP')
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       READ-1.
           MOVE +80 TO RECL77.
           EXEC CICS
               READ FILE('TSTKSDP') EQUAL
                    INTO(REC77) LENGTH(RECL77)
                    RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       READ-UPDATE-1.
           MOVE +80 TO RECL77.
           EXEC CICS
               READ FILE('TSTKSDP') EQUAL
                    INTO(REC77) LENGTH(RECL77)
             UPDATE RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       READNEXT-1.
           MOVE +80 TO RECL77.
           EXEC CICS
           READNEXT FILE('TSTKSDP')
                    INTO(REC77) LENGTH(RECL77)
                    RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           IF RESP77 = DFHRESP(ENDFILE) MOVE 0 TO RESP77.
           PERFORM NOTE-UNEXPECTED.

       READPREV-1.
           MOVE +80 TO RECL77.
           EXEC CICS
           READPREV FILE('TSTKSDP')
                    INTO(REC77) LENGTH(RECL77)
                    RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           IF RESP77 = DFHRESP(ENDFILE) MOVE 0 TO RESP77.
           PERFORM NOTE-UNEXPECTED.

       WRITE-1.
           EXEC CICS
              WRITE FILE('TSTKSDP')
                    FROM(REC77) LENGTH(80)
                    RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       REWRITE-1.
           EXEC CICS
            REWRITE FILE('TSTKSDP')
                    FROM(REC77) LENGTH(80)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       DELETE-1.
           EXEC CICS
             DELETE FILE('TSTKSDP')
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       DELETE-2.
           MOVE +0 TO NUM77.
           EXEC CICS
             DELETE FILE('TSTKSDP')
                    RIDFLD(KEY77) KEYLENGTH(6)
                    NUMREC(NUM77)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       DELETE-3.
           MOVE +0 TO NUM77.
           EXEC CICS
             DELETE FILE('TSTKSDP')
                    RIDFLD(KEY77) KEYLENGTH(5)
            GENERIC NUMREC(NUM77)
                    RESP(RESP77)
           END-EXEC.
           PERFORM NOTE-UNEXPECTED.

       UNLOCK-1.
           EXEC CICS
             UNLOCK FILE('TSTKSDP')
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
 ENTRY TESTDKP
 NAME  TESTDKP(R)
/*
//


       SCRIPT-1A.
      * should purge 5 '33333' records - works
           MOVE '33333' TO KEY77.
           MOVE +0 TO NUM77.
           EXEC CICS
             DELETE FILE('TSTKSDP')
                    RIDFLD(KEY77) KEYLENGTH(5)
                    GENERIC NUMREC(NUM77)
                    RESP(RESP77)
           END-EXEC.
           GO TO DO-IT-AGAIN.

       SCRIPT-1B.
      * should purge 1 '111111' records - works
           MOVE '111111' TO KEY77.
           MOVE +0 TO NUM77.
           MOVE +80 TO RECL77.
           EXEC CICS
               READ FILE('TSTKSDP')
                    INTO(REC77) LENGTH(RECL77)
             UPDATE RIDFLD(KEY77) KEYLENGTH(6)
                    RESP(RESP77)
           END-EXEC.
           EXEC CICS
             DELETE FILE('TSTKSDP')
                    RESP(RESP77)
           END-EXEC.
           GO TO DO-IT-AGAIN.

