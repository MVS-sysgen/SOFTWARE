//DELAYTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
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

      * EXEC KICKS DELAY
      *      [INTERVAL(hhmmss) |
      *       TIME(hhmmss) |
      *       FOR [HOURS(hh)] [MINUTES(mm)] [SECONDS(ss)] |
      *       UNTIL [HOURS(hh)] [MINUTES(mm)] [SECONDS(ss)]]
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
       77  WS-BIN-DELAY  PIC S9(8) COMP VALUE +0.
       77  RC            PIC S9(4) COMP VALUE +0.

       01  WS-DISP-TIME  PIC 9(6).
       01  WS-DISP-TIME2 REDEFINES WS-DISP-TIME.
           05  WS-HH     PIC 99.
           05  WS-MM     PIC 99.
           05  WS-SS     PIC 99.

       PROCEDURE DIVISION.

      *
      * first a set of absolute delays
      *

      *    10 second delay
           EXEC KICKS DELAY INTERVAL(10) RESP(RC) END-EXEC.

      *    10 second delay
           MOVE +10 TO WS-BIN-DELAY.
           EXEC KICKS DELAY INTERVAL(WS-BIN-DELAY) RESP(RC) END-EXEC.

      *    1 minute (not 100 second) delay
           EXEC KICKS DELAY INTERVAL(000100) RESP(RC) END-EXEC.

      *    5 minute delay - should fail as KICKS rejects > 3 minutes
           EXEC KICKS DELAY INTERVAL(000500) RESP(RC) END-EXEC.

      *    10 second delay
           EXEC KICKS DELAY FOR SECONDS(10) RESP(RC) END-EXEC.

      *    1 minute 10 second delay
           EXEC KICKS DELAY
             FOR MINUTES(1) SECONDS(10) RESP(RC)
           END-EXEC.

      *    1 hour 1 minute 10 second delay - should fail
           EXEC KICKS DELAY
             FOR HOURS(1) MINUTES(1) SECONDS(10) RESP(RC)
           END-EXEC.

      *
      * now a set of relative delays -- wait until a certain
      * time, meaning how long you wait depends on what time
      * it is when you do the EXEX KICKS...
      *

      *    wait until 12:01 am - probably fails 'expired'
           EXEC KICKS DELAY TIME(000001) RESP(RC) END-EXEC.

      *    wait until 11:59 pm - probably fails 'invreq'
           EXEC KICKS DELAY
             UNTIL HOURS(23) MINUTES(59) SECONDS(0) RESP(RC)
           END-EXEC.

      *    get current time (ASKTIME wo/ABSTIME just updates EIB)
           EXEC KICKS ASKTIME END-EXEC.

      *    compute a time 30 seconds from now and wait for it
           ADD 30 TO EIBTIME GIVING WS-BIN-DELAY.
           EXEC KICKS DELAY TIME(WS-BIN-DELAY) RESP(RC) END-EXEC.

      *    compute a time 30 seconds from now and wait for it
           EXEC KICKS ASKTIME END-EXEC.
           ADD 30 TO EIBTIME GIVING WS-BIN-DELAY.
           MOVE WS-BIN-DELAY TO WS-DISP-TIME.
           EXEC KICKS DELAY
             UNTIL HOURS(WS-HH) MINUTES(WS-MM) SECONDS(WS-SS)
             RESP(RC)
           END-EXEC.

      *    done now...
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
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=120)
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
KEDF ON<ENTER>
TCOB<ENTER>
/*
//
