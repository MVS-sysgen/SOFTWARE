//TSPTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC  PROC=K2KCOBCL
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

      * EXEC KICKS DELETEQ TS
      *       QUEUE(name)
      * END-EXEC.
      *
      * EXEC KICKS READQ TS
      *       QUEUE(name)
      *       INTO(data-area) [LENGTH(data-area)]
      *      [NUMITEMS(data-area)] [ITEM(data-value) | NEXT]
      * END-EXEC.
      *
      * EXEC KICKS WRITEQ TS
      *       QUEUE(name)
      *       FROM(data-area) [LENGTH(data-area)]
      *      [ITEM(data-value) [REWRITE]]
      *      [NUMITEMS(data-area)] [MAIN | AUXILIARY]
      *       NOSUSPEND
      * END-EXEC.

      * In KICKS, WRITEQ TS (and READQ TD) assume NOSUSPEND even if
      * you don't specify it, in which case a 'remark' (return code 2)
      * results at compile time to alert you to the issue.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
       77  RC            PIC S9(4) COMP VALUE +0.
       77  NUM-CARDS     PIC S9(4) COMP VALUE +0.
       77  CARD-NUM      PIC S9(4) COMP VALUE +0.
       77  CARD-LENGTH   PIC S9(4) COMP VALUE +80.
       77  CARD          PIC X(80) VALUE SPACES.

       01  READ-DIR      PIC S9(4) COMP VALUE -1.
           88  READ-FWD  VALUE +1.
           88  READ-BWD  VALUE -1.

<NPRO>
      * Since this entire test is 'PRO only' it uses the 'KLASTCCP'
      * subroutine to set the KICKS return code when it's run in a
      * non-PRO system.

       01  LAST-CA.
           05  LAST-CA-RETURN PIC S9(4) COMP VALUE +0.
           05  LAST-CA-LASTCC PIC S9(4) COMP VALUE +0.

       PROCEDURE DIVISION.

           MOVE +8 to LAST-CA-LASTCC.
           EXEC KICKS LINK PROGRAM('KLASTCCP') NOHANDLE
               COMMAREA(LAST-CA) END-EXEC.
           EXEC KICKS RETURN END-EXEC.
</NPRO>


<PRO>
       PROCEDURE DIVISION.

           DISPLAY 'delete queue'
           EXEC KICKS DELETEQ TS
             QUEUE('TSTST')
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 AND
              RC NOT EQUAL DFHRESP(QIDERR) THEN
               DISPLAY 'BAD RETURN FROM DELETEQ TS ', RC
               EXEC KICKS RETURN END-EXEC.

           DISPLAY 'reading cards'.
       READ-CARDS.
           EXEC KICKS READQ TD
                 QUEUE('SYSI') INTO(CARD) LENGTH(CARD-LENGTH)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN GO TO DONE-READING-TD.
           ADD +1 TO NUM-CARDS.

           EXEC KICKS WRITEQ TS QUEUE('TSTST')
                 FROM(CARD) LENGTH(CARD-LENGTH)
           END-EXEC.

           DISPLAY CARD.

           GO TO READ-CARDS.

       DONE-READING-TD.
           IF RC NOT EQUAL KIKRESP(QZERO) THEN
               DISPLAY 'BAD RETURN FROM READQ TD', RC
               EXEC KICKS RETURN END-EXEC.

           DISPLAY ' '.
           IF READ-FWD THEN
               DISPLAY 'reading TS forward  (direct)'
           ELSE
               DISPLAY 'reading TS backward (direct)'.
           PERFORM READ-AND-PRINT THRU RAP-EXIT.

           EXEC KICKS SYNCPOINT END-EXEC.

           DISPLAY ' '.
           IF READ-FWD THEN
               DISPLAY 'reading TS forward  (direct)'
           ELSE
               DISPLAY 'reading TS backward (direct)'.
           PERFORM READ-AND-PRINT THRU RAP-EXIT.

       DO-SOME-READ-NEXTS.
           DISPLAY ' '.
           DISPLAY 'reading TS forwards (next)'
           EXEC KICKS READQ TS
                 QUEUE('TSTST') INTO(CARD) ITEM(1)
           END-EXEC.
           DISPLAY CARD.

           EXEC KICKS READQ TS
                 QUEUE('TSTST') INTO(CARD) NEXT
           END-EXEC.
           DISPLAY CARD.

           EXEC KICKS READQ TS
                 QUEUE('TSTST') INTO(CARD) NEXT
           END-EXEC.
           DISPLAY CARD.

       DO-REWRITE-TEST.
           DISPLAY ' '.
           DISPLAY 're-write test'
           MOVE ALL '4' TO CARD.
           EXEC KICKS WRITEQ TS QUEUE('TSTST')
                 FROM(CARD) LENGTH(80)
                 REWRITE ITEM(2)
           END-EXEC.

           DISPLAY ' '.
           IF READ-FWD THEN
               DISPLAY 'reading TS forward  (direct)'
           ELSE
               DISPLAY 'reading TS backward (direct)'.
           PERFORM READ-AND-PRINT THRU RAP-EXIT.

       QUIT.
           DISPLAY 'delete queue'
           EXEC KICKS DELETEQ TS
             QUEUE('TSTST')
           END-EXEC.

           EXEC KICKS RETURN END-EXEC.

       READ-AND-PRINT.
      * forward or backward by item number...
           IF READ-FWD COMPUTE CARD-NUM = +0.
           IF READ-BWD COMPUTE CARD-NUM = NUM-CARDS + 1.

       RAP-AGAIN.
           IF READ-FWD ADD +1 TO CARD-NUM.
           IF READ-BWD ADD -1 TO CARD-NUM.
           EXEC KICKS READQ TS
                 QUEUE('TSTST') INTO(CARD)
                 ITEM(CARD-NUM)
                 RESP(RC)
           END-EXEC.
           IF RC NOT EQUAL +0 THEN GO TO RAP-WRAPUP.

           DISPLAY CARD.
           GO TO RAP-AGAIN.

       RAP-WRAPUP.
           IF RC NOT EQUAL KIKRESP(ITEMERR) THEN
               DISPLAY 'BAD RETURN FROM READQ TS', RC
               EXEC KICKS RETURN END-EXEC.

           MULTIPLY -1 BY READ-DIR.

       RAP-EXIT.
           EXIT.
</PRO>
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
//*        use TRCFLAGS=3 for auxtrace
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
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=V,BLKSIZE=2000)
//SYSUDUMP DD SYSOUT=*
//*
//SYSO     DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSI     DD *
3333333333333333333333333333333
22222222222222222222222222222
11111111111111111111111111
/*
//KIKTEMP  DD DSN=K.S.V1R5M0.KIKTEMP,DISP=SHR
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
<CLEAR>            PREPARE TO ENTER NEXT TRANSACTION
CRLP BORDER<ENTER> SHOW CRLP OPTIONS
<CLEAR>            PREPARE TO ENTER NEXT TRANSACTION
KEDF ON<ENTER>     TURN ON KEDF
<CLEAR>            PREPARE TO ENTER NEXT TRANSACTION
TCOB<ENTER>        START THE TEST
/*
//
