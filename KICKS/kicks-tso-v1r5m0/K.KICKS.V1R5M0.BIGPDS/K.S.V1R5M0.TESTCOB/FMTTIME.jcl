//FMTTIME  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
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

      * EXEC KICKS FORMATTIME ABSTIME(data-value)
      *       [YYDDD(data-area)]  [YYYYDDD(data-area)]
      *       [YYMMDD(data-area)] [YYYYMMDD(data-area)]
      *       [YYDDMM(data-area)] [YYYYDDMM(data-area)]
      *       [DDMMYY(data-area)] [DDMMYYYY(data-area)]
      *       [MMDDYY(data-area)] [MMDDYYYY(data-area)]
      *       [DAYCOUNT(data-area)]
      *       [DAYOFWEEK(data-area)]
      *       [DAYOFMONTH(data-area)]
      *       [MONTHOFYEAR(data-area)]
      *       [YEAR(data-area)]
      *       [DATESEP(data-value)]
      *       [TIME(data-area)
      *       [TIMESEP(data-value)]
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
       77  WS-ABSTIME          PIC S9(15) COMP-3.
       77  WS-FMTDATE          PIC X(20).
       77  WS-FMTTIME          PIC X(8).
       77  WS-BIN              PIC S9(8) COMP.
       77  WS-BLANK            PIC X VALUE ' '.

       PROCEDURE DIVISION.

           EXEC KICKS ASKTIME ABSTIME(WS-ABSTIME) END-EXEC.

           MOVE SPACES TO WS-FMTTIME.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             TIME(WS-FMTTIME)
           END-EXEC.
           DISPLAY WS-FMTTIME.

           MOVE SPACES TO WS-FMTTIME.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             TIME(WS-FMTTIME) TIMESEP(':')
           END-EXEC.
           DISPLAY WS-FMTTIME.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYDDD(WS-FMTDATE)
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYDDD(WS-FMTDATE) DATESEP('-')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYYYDDD(WS-FMTDATE) DATESEP('-')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYMMDD(WS-FMTDATE) DATESEP('/')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYYYMMDD(WS-FMTDATE) DATESEP('/')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYDDMM(WS-FMTDATE) DATESEP('/')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YYYYDDMM(WS-FMTDATE) DATESEP('/')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             DDMMYY(WS-FMTDATE) DATESEP('/')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             DDMMYYYY(WS-FMTDATE) DATESEP('/')
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             MMDDYY(WS-FMTDATE) DATESEP(WS-BLANK)
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE SPACES TO WS-FMTDATE.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             MMDDYYYY(WS-FMTDATE) DATESEP(WS-BLANK)
           END-EXEC.
           DISPLAY WS-FMTDATE.

           MOVE +0 TO WS-BIN.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             DAYCOUNT(WS-BIN)
           END-EXEC.
           DISPLAY WS-BIN.

           MOVE +0 TO WS-BIN.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             DAYOFWEEK(WS-BIN)
           END-EXEC.
           DISPLAY WS-BIN.

           MOVE +0 TO WS-BIN.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             DAYOFMONTH(WS-BIN)
           END-EXEC.
           DISPLAY WS-BIN.

           MOVE +0 TO WS-BIN.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             MONTHOFYEAR(WS-BIN)
           END-EXEC.
           DISPLAY WS-BIN.

           MOVE +0 TO WS-BIN.
           EXEC KICKS FORMATTIME ABSTIME(WS-ABSTIME)
             YEAR(WS-BIN)
           END-EXEC.
           DISPLAY WS-BIN.


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

