//DCPTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTCOB.

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

      * EXEC KICKS DELETEQ TD
      *    QUEUE(name)
      * END-EXEC.
      *
      * EXEC KICKS READQ TD
      *    QUEUE(name) INTO(data-area)
      *   [LENGTH(data-area)] NOSUSPEND
      * END-EXEC.
      *
      * EXEC KICKS WRITEQ TD
      *    QUEUE(name)
      *    FROM(data-area) [LENGTH(data-area)]
      * END-EXEC.
      *
      * EXEC KICKS SPOOLOPEN OUTPUT
      *    TOKEN(data-area) { USERID(data-value) | WRITER(data-value)}
      *    NODE(data-value) [ CLASS(data-value) ] [ PRINT | PUNCH ]
      * END-EXEC.
      *
      * EXEC KICKS SPOOLOPEN INPUT                ** NOT IMPLEMENTED **
      *    TOKEN(data-area) USERID(data-value)  [ CLASS(data-value) ]
      * END-EXEC.
      *
      * EXEC KICKS SPOOLREAD                      ** NOT IMPLEMENTED **
      *    TOKEN(data-area)  INTO(data-area)
      *    MAXFLENGTH(data-value) TOFLENGTH(data-area)
      * END-EXEC.
      *
      * EXEC KICKS SPOOLWRITE
      *    TOKEN(data-area)  FROM(data-area)  FLENGTH(data-value)
      *   [ LINE | PAGE ]
      * END-EXEC.
      *
      * EXEC KICKS SPOOLCLOSE
      *    TOKEN(data-area)  [ KEEP ]
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
       77  RC            PIC S9(4) COMP VALUE +0.
       77  INTRDR-TOKEN  PIC X(8)  VALUE SPACES.
       77  SYSOUT-TOKEN  PIC X(8)  VALUE SPACES.
       77  NUM-CARDS     PIC S9(4) COMP VALUE +0.
       77  CARD-LENGTH   PIC S9(4) COMP VALUE +80.

       01  CARD.
           05  CR-1      PIC 9.
           05  FILLER    PIC X(79).
       01  CARD-REDEF REDEFINES CARD.
           05  FILLER    PIC X.
           05  CR-ALL    PIC X(79).

       01  LOG-MSG.
           05  CARD-COUNT PIC Z9(4).
           05  FILLER    PIC X(20) VALUE ' JCL CARDS SUBMITED.'.

       PROCEDURE DIVISION.
<PRO>
      * these are tests of INTRApartition queues.

      * DELETEQ
      * WRITEQ 5 records
      * READQ the 5 records
      * DELETEQ again

           EXEC KICKS DELETEQ TD
                 QUEUE('TEST') NOHANDLE
           END-EXEC.
           MOVE +0 TO NUM-CARDS.

       WRITE-INTRA.
           MOVE NUM-CARDS TO CR-1. ADD 1 TO CR-1.
           MOVE CARD TO CR-ALL.
           DISPLAY CARD.
           EXEC KICKS WRITEQ TD
                 QUEUE('TEST') FROM(CARD) LENGTH(CARD-LENGTH)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM WRITEQ ', RC
               EXEC KICKS RETURN END-EXEC.
           ADD +1 TO NUM-CARDS.
           IF NUM-CARDS < 5 THEN GO TO WRITE-INTRA.
           MOVE +0 TO NUM-CARDS.
           DISPLAY ' '.

       READ-INTRA.
           EXEC KICKS READQ TD
                 QUEUE('TEST') INTO(CARD) LENGTH(CARD-LENGTH)
                 NOSUSPEND
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM READQ (INTRA)', RC
               EXEC KICKS RETURN END-EXEC.
           DISPLAY CARD.
           ADD +1 TO NUM-CARDS.
           IF NUM-CARDS < 5 THEN GO TO READ-INTRA.
     *
           EXEC KICKS DELETEQ TD
                 QUEUE('TEST') RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM DELETEQ (2ND) ', RC
               EXEC KICKS RETURN END-EXEC.
</PRO>
      * these are tests of EXTRApartition queues.

      * SPOOLOPEN intrdr, then read cards with READQ and send
      * to intrdr with SPOOLWRITE, and on eof do SPOOLCLOSE
      * to submit job (if num cards read > 0). write message
      * with num cards submitted with WRITEQ.

           MOVE +0 TO NUM-CARDS.
           DISPLAY ' '.
       READ-CARDS.
           EXEC KICKS READQ TD
                 QUEUE('SYSI') INTO(CARD) LENGTH(CARD-LENGTH)
                 NOSUSPEND
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN GO TO DONE-READING.
           ADD +1 TO NUM-CARDS.
           IF NUM-CARDS NOT EQUAL +1 THEN GO TO ALREADY-OPEN.
           EXEC KICKS SPOOLOPEN OUTPUT
                 TOKEN(INTRDR-TOKEN) WRITER('INTRDR')
                 NODE('*')
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM SPOOLOPEN (1ST) ', RC
               EXEC KICKS RETURN END-EXEC.                                .

       ALREADY-OPEN.
           EXEC KICKS SPOOLWRITE
                 TOKEN(INTRDR-TOKEN) FROM(CARD) FLENGTH(80)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM SPOOLWRITE ', RC
               EXEC KICKS RETURN END-EXEC.                                .
           GO TO READ-CARDS.

       DONE-READING.
           IF RC NOT EQUAL KIKRESP(QZERO) THEN
               DISPLAY 'BAD RETURN FROM READQ ', RC
               EXEC KICKS RETURN END-EXEC.
           IF NUM-CARDS EQUAL +0 THEN GO TO LOG-JOB.
           EXEC KICKS SPOOLCLOSE
                 TOKEN(INTRDR-TOKEN)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM SPOOLCLOSE (1ST)', RC
               EXEC KICKS RETURN END-EXEC.

       LOG-JOB.
           MOVE NUM-CARDS TO CARD-COUNT.
           EXEC KICKS WRITEQ TD
                 QUEUE('LOG') FROM(LOG-MSG) LENGTH(24)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM WRITEQ ', RC
               EXEC KICKS RETURN END-EXEC.

      * SPOOLOPEN sysout, then write ten lines of all 'KICKS '
      * using SPOOLWRITE, then SPOOLCLOSE to print the lines
      * then write message the sysout sent with WRITEQ.

           EXEC KICKS SPOOLOPEN OUTPUT
                 TOKEN(SYSOUT-TOKEN) CLASS('A')
                 USERID('*') NODE('*')
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM SPOOLOPEN (2ND) ', RC
               EXEC KICKS RETURN END-EXEC.                                .

           MOVE ALL 'KICKS ' TO LOG-MSG.
           PERFORM P1. PERFORM P1. PERFORM P1. PERFORM P1. PERFORM P1.
           PERFORM P1. PERFORM P1. PERFORM P1. PERFORM P1. PERFORM P1.

           EXEC KICKS SPOOLCLOSE
                 TOKEN(SYSOUT-TOKEN)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM SPOOLCLOSE (2ND)', RC
               EXEC KICKS RETURN END-EXEC.

      *    done now...

           EXEC KICKS RETURN END-EXEC.

      *    performed procedure to print one line to 'report'

       P1.
           EXEC KICKS SPOOLWRITE
                 TOKEN(SYSOUT-TOKEN) FROM(LOG-MSG) FLENGTH(24)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN
               DISPLAY 'BAD RETURN FROM SPOOLWRITE (2ND)', RC
               EXEC KICKS RETURN END-EXEC.

/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTCOB
 NAME  TESTCOB(R)
/*
//GO EXEC PGM=KIKSIP1$,COND=(4,LT,TESTCOB.LKED),
//   REGION=2000K,TIME=1,
//   PARM='SIT=B$ ICVR=0'
//* kiksip1$ comes from steplib...
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* tables come from skikload...
//SKIKLOAD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* programs & maps come from kikrpl...
//KIKRPL   DD DSN=&&GOSET,DISP=(OLD,DELETE),
//         DCB=BLKSIZE=32000
//         DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//*
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSOUT   DD SYSOUT=*,DCB=BLKSIZE=132
//CRLPOUT  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//TRANDUMP DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSUDUMP DD SYSOUT=*
//*
//SYSO     DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSI     DD DATA,DLM=XX
//DCPTST2  JOB  MSGCLASS=A,MSGLEVEL=(1,1),USER=HERC01,TYPRUN=SCAN
//  EXEC PGM=IEFBR14
//
XX
//*
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=120)
//*
//KIKTEMP  DD DSN=K.S.V1R5M0.KIKTEMP,DISP=SHR
//KIKINTRA DD DSN=K.S.V1R5M0.KIKINTRA,DISP=SHR
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
KEDF ON<ENTER>
TCOB<ENTER>
/*
//
