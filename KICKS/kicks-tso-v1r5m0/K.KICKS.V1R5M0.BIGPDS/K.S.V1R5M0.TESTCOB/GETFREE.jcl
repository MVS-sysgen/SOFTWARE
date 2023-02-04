//GETFREE  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
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

      * EXEC KICKS GETMAIN
      *      SET(pointer-ref)
      *      { LENGTH(data-value) | FLENGTH(data-value) [BELOW] }
      *      [INITIMG(data-value)]
      *      [NOSUSPEND] [SHARED] {USERKEY | CICSKEY}]
      * END-EXEC.
      *
      * EXEC KICKS FREEMAIN
      *      { DATA(data-area) | DATAPOINTER(pointer-ref) }
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
<NCB2>
       77  WS-SET    PIC S9(8) COMP VALUE +0.
</NCB2>
<CB2>
       77  WS-SET    USAGE POINTER.
</CB2>
       77  WS-LOW    PIC X VALUE LOW-VALUES.
       77  WS-HIGH   PIC X VALUE HIGH-VALUES.
       77  WS-SPACE  PIC X VALUE SPACES.

       LINKAGE SECTION.
<NCB2>
       01  BLL-CELLS.
           05  FILLER                  PIC S9(8) COMP.
           05  BLL-STOR1               PIC S9(8) COMP.
           05  BLL-STOR1B              PIC S9(8) COMP.
</NCB2>
       01  STOR1.
           05  S1-1                    PIC X(1000).
           05  FILLER                  PIC X(3000).
           05  S1-LOTS                 PIC X(1000).
           05  S1-MORE                 PIC X(1000).

       PROCEDURE DIVISION.

      * plain old getmain...
           EXEC KICKS GETMAIN SET(WS-SET) FLENGTH(2400) END-EXEC.
      * NOSTG condition does not result in abend, must test...
           IF EIBRESP NOT = KIKRESP(NORMAL) THEN
               DISPLAY 'BAD GETMAIN 1'
               EXEC KICKS ABEND ABCODE('GETM') END-EXEC.

      * getmain initializing gotten storage to high values...
           EXEC KICKS GETMAIN SET(WS-SET) FLENGTH(240)
                INITIMG(WS-HIGH)
           END-EXEC.
           IF EIBRESP NOT = KIKRESP(NORMAL) THEN
               DISPLAY 'BAD GETMAIN 2'
               EXEC KICKS ABEND ABCODE('GETM') END-EXEC.

      * getmain obtaining storage that is 'shared' - meaning it
      * does not automatically go away at task end - must be
      * explicitly freed.
           EXEC KICKS GETMAIN SET(WS-SET) LENGTH(240)
                INITIMG(WS-LOW) SHARED
           END-EXEC.
           IF EIBRESP NOT = KIKRESP(NORMAL) THEN
               DISPLAY 'BAD GETMAIN 3'
               EXEC KICKS ABEND ABCODE('GETM') END-EXEC.

      * freemain the above 'shared' storage
           EXEC KICKS FREEMAIN DATAPOINTER(WS-SET) END-EXEC.

      * getmain for STOR1 item
           EXEC KICKS GETMAIN SET(WS-SET) FLENGTH(6000)
                INITIMG(WS-SPACE) END-EXEC.
           IF EIBRESP NOT = KIKRESP(NORMAL) THEN
               DISPLAY 'BAD GETMAIN 4'
               EXEC KICKS ABEND ABCODE('GETM') END-EXEC.
<CB2>
      * cobol II uses SET instead of BLL's
           SET ADDRESS OF STOR1 TO WS-SET.
</CB2>
<NCB2>
      * ansi cobol uses BLL's instead of SET, and it needs
      * one BLL per 4096 bytes (or part thereof) for 01
           MOVE WS-SET TO BLL-STOR1.
           ADD +4096 BLL-STOR1 GIVING BLL-STOR1B.
</NCB2>

           MOVE ALL '1' TO S1-1.
           MOVE ALL 'L' TO S1-LOTS.
           MOVE ALL 'M' TO S1-MORE.
           DISPLAY STOR1.

      * freemain the 'STOR1' storage by data (instead of pointer)
      *    EXEC KICKS FREEMAIN DATAPOINTER(WS-SET) END-EXEC.
           EXEC KICKS FREEMAIN DATA(STOR1) END-EXEC.

           EXEC KICKS RETURN END-EXEC.

      * note we are stopping without ever freemain'ing the first
      * two pieces of storage we got. that's OK, since those were
      * not acquired 'SHARED', so KICKS will freemain them when
      * this task ends (the above RETURN).

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
//   PARM='SIT=B$ ICVR=0 '
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
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=V,BLKSIZE=2000)
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
KEDF ON<ENTER>
TCOB<ENTER>
/*
//
